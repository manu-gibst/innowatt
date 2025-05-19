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

  bool _hasMoreChats = true;
  DocumentSnapshot<Chat>? _lastDocument;
  late final Map<String, Chat> _chatsMap;

  final List<Chat> _sortedChats;

  void _initChats() {
    print("In _initChats()");
    final savedChats = _getChatsMap() ?? <String, Chat>{};
    _chatsMap.addAll(savedChats);
    _sortedChats.addAll(_chatsMap.values);
    _sortedChats.sort(
      (a, b) => b.updatedTime!.compareTo(a.updatedTime!),
    );
    print("Initial _sortedChats = $_sortedChats");
  }

  final SharedPreferences? _prefs;

  Timestamp? _lastFetchTimestamp;
  static const lastFetchTimestampKey = '__lastFetchTimestamp__';
  static const chatsMapKey = '__chatsMap__';

  bool get hasMoreChats => _hasMoreChats;

  Future<void> _updateLastFetchTime() async {
    await _prefs!
        .setInt(lastFetchTimestampKey, Timestamp.now().microsecondsSinceEpoch);
  }

  Timestamp _getLastFetchTime() {
    return Timestamp.fromMicrosecondsSinceEpoch(
      _prefs!.getInt(lastFetchTimestampKey) ?? 0,
    );
  }

  void _updateChatsMap() {
    final List<String> li = _sortedChats.map((chat) {
      final chatJson = chat.toJson();
      chatJson['updated_time'] = chat.updatedTime!.microsecondsSinceEpoch;
      return jsonEncode(chatJson);
    }).toList();
    _prefs!.setStringList(chatsMapKey, li);
  }

  Map<String, Chat>? _getChatsMap() {
    final jsonList = _prefs!.getStringList(chatsMapKey);
    if (jsonList == null) return null;

    Map<String, Chat> result = {};
    for (var json in jsonList) {
      print("in _getChatsMap()");
      print("json = $json");
      final chatJson = jsonDecode(json);
      chatJson['updated_time'] =
          Timestamp.fromMicrosecondsSinceEpoch(chatJson['updated_time']);
      print("chatJson = $chatJson");
      final chat = Chat.fromJson(chatJson);
      print("chat = $chat");
      result[chat.chatId!] = chat;
    }
    print(result);
    return result;
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
      print('#DEBUG IN [addUser]#: ERROR(${e.code}): $e');
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
    print("#DEBUG# loadOnlyNew = $loadOnlyNew");
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

    chatsQuery.snapshots().listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        _chatsController.add(_sortedChats);
      }
      if (snapshot.docs.isNotEmpty) {
        final newChats = snapshot.docs.map((e) => e.data()).toList();
        print("New Chats fetched: $newChats");

        for (var chat in newChats) {
          print('Checking if _chatsMap has Chat ${chat.chatId!}');
          if (_chatsMap.containsKey(chat.chatId!)) {
            if (_sortedChats.remove(chat)) {
              print("Chat removed successfully; _sortedChats = $_sortedChats");
            } else {
              print("Failed to remove chat; _sortedChats = $_sortedChats");
            }
          }
          _sortedChats.insert(0, chat);
          print('_sortedChats = $_sortedChats');
          _chatsMap[chat.chatId!] = chat;
        }

        _chatsController.add(_sortedChats);
        print("#DEBUG# sortedChats = $_sortedChats");

        _lastDocument = snapshot.docs.last;

        _hasMoreChats = newChats.length == 20;

        _lastFetchTimestamp = Timestamp.now();
        _updateLastFetchTime();
      }
    });
  }

  Stream<List<Chat>> chatsStream({
    required String uid,
    bool loadOnlyNew = false,
  }) {
    print("In chatsStream");
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

  void dispose() {
    _chatsController.close();
    _updateChatsMap();
  }
}
