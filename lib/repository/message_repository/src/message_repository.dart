import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innowatt/repository/message_repository/src/exceptions/exception.dart';
import 'package:innowatt/repository/message_repository/src/models/models.dart';

class MessageRepository {
  MessageRepository({required this.chatId});
  final String chatId;

  CollectionReference<Message> get _messages => FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .withConverter(
          fromFirestore: Message.fromFirestore,
          toFirestore: (Message message, _) => message.toFirestore());

  DocumentSnapshot<Message>? _lastMessage;
  bool _hasMoreChats = true;
  final List<List<Message>> _allPagedMessages = [];
  final StreamController<List<Message>> _messagesController =
      StreamController<List<Message>>.broadcast();

  bool get hasMoreChats => _hasMoreChats;

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
    print(message);
    try {
      final messages = _messages;
      messages.doc().set(message);
    } on FirebaseException catch (e) {
      print('#DEBUG IN [sendMessage]#: ERROR(${e.code}): $e');
      throw FirestoreDatabaseFailure.fromCode(e.code);
    } catch (_) {
      throw FirestoreDatabaseFailure();
    }
  }

  void _requestMessages() {
    var pageMessagesQuery =
        _messages.orderBy('created_at', descending: true).limit(20);
    if (_lastMessage != null) {
      pageMessagesQuery = pageMessagesQuery.startAfterDocument(_lastMessage!);
    }

    if (!_hasMoreChats) return;

    var currentRequestIndex = _allPagedMessages.length;

    pageMessagesQuery.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final messages = snapshot.docs.map((e) => e.data()).toList();

        final pageExists = currentRequestIndex < _allPagedMessages.length;

        if (pageExists) {
          _allPagedMessages[currentRequestIndex] = messages;
        } else {
          _allPagedMessages.add(messages);
        }

        final allMessages = _allPagedMessages.fold<List<Message>>(
          <Message>[],
          (initialValue, pageItems) => initialValue..addAll(pageItems),
        );
        _messagesController.add(allMessages);

        if (currentRequestIndex == _allPagedMessages.length - 1) {
          _lastMessage = snapshot.docs.last;
        }

        _hasMoreChats = messages.length == 20;
      }
    });
  }

  Stream<List<Message>> messagesStream() {
    _requestMessages();
    print('in messagesStream');
    print(_allPagedMessages);
    return _messagesController.stream;
  }

  Future<bool> get isMessagesEmpty async {
    final querySnapshot = await _messages.limit(1).get();
    return querySnapshot.docs.isEmpty;
  }
}
