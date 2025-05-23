import 'dart:async';
import 'dart:convert';

import 'package:innowatt/repository/chat_repository/src/exceptions/exception.dart';
import 'package:innowatt/repository/chat_repository/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  ChatRepository({
    SharedPreferences? prefs,
    List<Chat>? chats,
  })  : _prefs = prefs,
        _sortedChats = chats ?? [],
        _chatsMap = {} {
    if (prefs != null) _initChats();
  }
  final _usersCollection =
      FirebaseFirestore.instance.collection('users').withConverter(
            fromFirestore: User.fromFirestore,
            toFirestore: (User user, _) => user.toFirestore(),
          );
  final _chatsCollection =
      FirebaseFirestore.instance.collection('chats').withConverter(
            fromFirestore: Chat.fromFirestore,
            toFirestore: (Chat chat, _) => chat.toFirestore(),
          );

  final StreamController<List<Chat>> _chatsController =
      StreamController<List<Chat>>.broadcast();
  StreamSubscription? _chatsSubscription;

  bool _hasMoreChats = true;
  DocumentSnapshot<Chat>? _lastDocument;
  final Map<String, Chat> _chatsMap;

  final List<Chat> _sortedChats;

  void _initChats() {
    final savedChats = _getChatsMap() ?? <String, Chat>{};
    _chatsMap.addAll(savedChats);
    _sortedChats.addAll(_chatsMap.values);
    _sortedChats.sort(
      (a, b) => b.updatedTime!.compareTo(a.updatedTime!),
    );
  }

  final SharedPreferences? _prefs;

  Timestamp? _lastFetchTimestamp;
  static const _lastFetchTimestampKey = '__lastFetchTimestamp__';
  static const _chatsMapKey = '__chatsMap__';

  bool get hasMoreChats => _hasMoreChats;

  Future<void> _updateLastFetchTime() async {
    await _prefs!
        .setInt(_lastFetchTimestampKey, Timestamp.now().microsecondsSinceEpoch);
  }

  Timestamp? _getLastFetchTime() {
    final lastFetch = _prefs!.getInt(_lastFetchTimestampKey);
    if (lastFetch == null) return null;
    return Timestamp.fromMicrosecondsSinceEpoch(lastFetch);
  }

  Future<void> _updateChatsMap() async {
    final List<String> li = _sortedChats.map((chat) {
      final chatJson = chat.toJson();
      chatJson['updated_time'] = chat.updatedTime!.microsecondsSinceEpoch;
      return jsonEncode(chatJson);
    }).toList();
    final int end = li.length > 20 ? 20 : li.length;
    await _prefs!.setStringList(_chatsMapKey, li.sublist(0, end));
  }

  Map<String, Chat>? _getChatsMap() {
    final jsonList = _prefs!.getStringList(_chatsMapKey);
    if (jsonList == null) return null;

    Map<String, Chat> result = {};
    for (var json in jsonList) {
      final chatJson = jsonDecode(json);
      chatJson['updated_time'] =
          Timestamp.fromMicrosecondsSinceEpoch(chatJson['updated_time']);
      final chat = Chat.fromJson(chatJson);
      result[chat.chatId!] = chat;
    }
    return result;
  }

  static Future<void> deleteMemory(SharedPreferences prefs) async {
    await prefs.remove(_lastFetchTimestampKey).then((_) {
      assert(prefs.get(_lastFetchTimestampKey) == null);
      print("lastFetchTimestamp removed");
    });
    await prefs.remove(_chatsMapKey).then((_) {
      assert(prefs.get(_chatsMapKey) == null);
      print("chatsMap removed");
    });
  }

  void addUser({
    required String uid,
    required String email,
    String? fullname,
  }) {
    final user = User(
      uid: uid,
      email: email,
      fullname: fullname ?? '',
    );
    try {
      _usersCollection.doc(user.uid).set(user);
    } on FirebaseException catch (e) {
      throw FirestoreDatabaseFailure.fromCode(e.code);
    } catch (_) {
      throw FirestoreDatabaseFailure();
    }
  }

  void createSingleUserChat({
    required String uid,
    required String chatName,
  }) {
    final chat = Chat(
      name: chatName,
      uids: [uid],
      updatedTime: Timestamp.now(),
    );
    try {
      _chatsCollection.doc().set(chat);
    } on FirebaseException catch (e) {
      throw FirestoreDatabaseFailure.fromCode(e.code);
    } catch (_) {
      throw FirestoreDatabaseFailure();
    }
  }

  void requestChats({required String uid, bool loadOnlyNew = false}) {
    if (_lastFetchTimestamp == null) loadOnlyNew = false;

    var chatsQuery = _chatsCollection
        .where("uids", arrayContains: uid)
        .orderBy('updated_time', descending: true)
        .limit(20);
    if (_lastDocument != null) {
      chatsQuery = chatsQuery.startAfterDocument(_lastDocument!);
    }
    if (loadOnlyNew) {
      _lastFetchTimestamp ??= _getLastFetchTime();
      chatsQuery = chatsQuery.where(
        'updated_time',
        isGreaterThan: _lastFetchTimestamp,
      );
    }

    if (!_hasMoreChats) return;

    _chatsSubscription = chatsQuery.snapshots().listen((snapshot) async {
      if (snapshot.docs.isEmpty) {
        _chatsController.add(_sortedChats);
      }
      if (snapshot.docs.isNotEmpty) {
        final chats = snapshot.docs.map((e) => e.data()).toList();

        for (var chat in chats) {
          if (_chatsMap.containsKey(chat.chatId!)) {
            _sortedChats.remove(chat);
          }
          _sortedChats.insert(0, chat);
          _chatsMap[chat.chatId!] = chat;
        }

        _chatsController.add(_sortedChats);

        _lastDocument = snapshot.docs.last;

        _hasMoreChats = chats.length == 20;

        _lastFetchTimestamp = Timestamp.now();
        await _updateLastFetchTime();
      }
    }, onError: (e) {
      print('Error in chats stream: $e');
    });
  }

  Stream<List<Chat>> chatsStream({
    required String uid,
    bool loadOnlyNew = false,
  }) {
    requestChats(uid: uid, loadOnlyNew: loadOnlyNew);
    return _chatsController.stream;
  }

  Future<Chat> getChat({required String chatId}) async {
    try {
      final doc = await _chatsCollection.doc(chatId).get();
      final chat = doc.data()!;
      return chat;
    } on FirebaseException catch (e) {
      throw FirestoreDatabaseFailure.fromCode(e.code);
    } catch (_) {
      throw FirestoreDatabaseFailure();
    }
  }

  Future<bool> isChatsEmpty({required String uid}) async {
    final querySnapshot =
        await _chatsCollection.where("uids", arrayContains: uid).limit(1).get();
    return querySnapshot.docs.isEmpty;
  }

  void updateCreatedTime({required String chatId}) {
    _chatsCollection.doc(chatId).update({'updated_time': Timestamp.now()});
  }

  Future<void> dispose() async {
    await _chatsSubscription?.cancel();
    await _chatsController.close();
    if (_sortedChats.isNotEmpty && _prefs != null) {
      try {
        await _updateChatsMap();
      } catch (e) {
        print('Error while saving chats during dispose(): $e');
      }
    }
  }
}
