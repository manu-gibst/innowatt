import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innowatt/repository/message_repository/src/exceptions/exception.dart';
import 'package:innowatt/repository/message_repository/src/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageRepository {
  MessageRepository({
    required SharedPreferences prefs,
    required String chatId,
    List<Message>? messages,
  })  : _chatId = chatId,
        _prefs = prefs,
        _lastFetchTimestampKey = '__${chatId}_lastFetchTimestamp__',
        _messagesMapKey = '__${chatId}_messagesMapKey__',
        _sortedMessages = messages ?? [],
        _messagesMap = {} {
    _initChats();
  }

  CollectionReference<Message> get _messages => FirebaseFirestore.instance
      .collection('chats')
      .doc(_chatId)
      .collection('messages')
      .withConverter(
          fromFirestore: Message.fromFirestore,
          toFirestore: (Message message, _) => message.toFirestore());

  final SharedPreferences _prefs;

  String get chatId => _chatId;

  final String _chatId;
  DocumentSnapshot<Message>? _lastDocument;
  bool _hasMoreChats = true;
  final Map<String, Message> _messagesMap;
  final List<Message> _sortedMessages;

  final StreamController<List<Message>> _messagesController =
      StreamController<List<Message>>.broadcast();
  StreamSubscription? _messageSubscription;

  bool get hasMoreChats => _hasMoreChats;
  Timestamp? _lastFetchTimestamp;
  final String _lastFetchTimestampKey;
  final String _messagesMapKey;

  void _initChats() {
    final savedMessages = _getMessagesMap() ?? <String, Message>{};
    _messagesMap.addAll(savedMessages);
    _sortedMessages.addAll(_messagesMap.values);
    _sortedMessages.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );
  }

  Future<void> _updateLastFetchTime() async {
    await _prefs.setInt(
        _lastFetchTimestampKey, Timestamp.now().microsecondsSinceEpoch);
  }

  Timestamp _getLastFetchTime() {
    return Timestamp.fromMicrosecondsSinceEpoch(
      _prefs.getInt(_lastFetchTimestampKey) ?? 0,
    );
  }

  Future<void> _updateMessagesMap() async {
    final List<String> li = _sortedMessages.map((message) {
      final messageJson = message.toJson();
      messageJson['created_at'] = message.createdAt.microsecondsSinceEpoch;
      return jsonEncode(messageJson);
    }).toList();
    final int end = li.length > 20 ? 20 : li.length;
    await _prefs.setStringList(_messagesMapKey, li.sublist(0, end));
  }

  Map<String, Message>? _getMessagesMap() {
    final jsonList = _prefs.getStringList(_messagesMapKey);
    if (jsonList == null) return null;

    Map<String, Message> result = {};
    for (var json in jsonList) {
      final messageJson = jsonDecode(json);
      messageJson['created_at'] =
          Timestamp.fromMicrosecondsSinceEpoch(messageJson['created_at']);
      final message = Message.fromJson(messageJson);
      result[message.id!] = message;
    }
    return result;
  }

  void sendMessage({
    required String text,
    required String authorId,
    required String chatId,
  }) {
    final message = Message(
      authorId: authorId,
      createdAt: Timestamp.now(),
      text: text,
    );
    try {
      _messages.doc().set(message);
    } on FirebaseException catch (e) {
      throw FirestoreDatabaseFailure.fromCode(e.code);
    } catch (_) {
      throw FirestoreDatabaseFailure();
    }
  }

  void _requestMessages({bool loadOnlyNew = false}) {
    var messagesQuery = _messages.orderBy('created_at', descending: true);

    if (loadOnlyNew) {
      _lastFetchTimestamp ??= _getLastFetchTime();
      messagesQuery = messagesQuery.where(
        'created_at',
        isGreaterThan: _lastFetchTimestamp,
      );
    }
    messagesQuery = messagesQuery.limit(20);
    if (_lastDocument != null) {
      messagesQuery = messagesQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreChats) return;

    _messageSubscription = messagesQuery.snapshots().listen((snapshot) async {
      if (snapshot.docs.isEmpty) {
        _messagesController.add(_sortedMessages);
      }
      if (snapshot.docs.isNotEmpty) {
        final messages = snapshot.docs.map((e) => e.data()).toList();

        for (var message in messages) {
          if (!_messagesMap.containsKey(message.id!)) {
            _sortedMessages.insert(0, message);
            _messagesMap[message.id!] = message;
          }
        }

        _messagesController.add(_sortedMessages);

        _lastDocument = snapshot.docs.last;

        _hasMoreChats = messages.length == 20;

        _lastFetchTimestamp = Timestamp.now();
        await _updateLastFetchTime();
      }
    });
  }

  Stream<List<Message>> messagesStream({bool loadOnlyNew = false}) {
    _requestMessages(loadOnlyNew: loadOnlyNew);
    return _messagesController.stream;
  }

  Future<void> dispose() async {
    await _messageSubscription?.cancel();
    await _messagesController.close();
    if (_sortedMessages.isNotEmpty) {
      try {
        await _updateMessagesMap();
      } catch (e) {
        print('Error while saving messages during dispose(): $e');
      }
    }
  }
}
