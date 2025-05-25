import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_collection/firestore_collection.dart';
import 'package:innowatt/repository/message_repository/src/exceptions/exception.dart';
import 'package:innowatt/repository/message_repository/src/models/models.dart';

class MessageRepository {
  MessageRepository({
    required String chatId,
    List<Message>? messages,
  })  : _chatId = chatId,
        _dynamicCollection = FirestoreCollection(
          collection: FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .collection('messages'),
          initializeOnStart: true,
          pageSize: 20,
          serverOnly: false,
          live: true,
          queryList: [
            FirebaseFirestore.instance
                .collection('chats')
                .doc(chatId)
                .collection('messages')
          ],
          queryOrder: QueryOrder(orderField: 'created_at'),
        );

  CollectionReference<Message> get _messages => FirebaseFirestore.instance
      .collection('chats')
      .doc(_chatId)
      .collection('messages')
      .withConverter(
          fromFirestore: Message.fromFirestore,
          toFirestore: (Message message, _) => message.toFirestore());

  String get chatId => _chatId;

  final String _chatId;

  final FirestoreCollection _dynamicCollection;

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

  Stream<List<Message>> getMessageStream() {
    return _dynamicCollection.stream.map((snapshots) {
      if (snapshots == null || snapshots.isEmpty) return <Message>[];
      return snapshots.map((doc) {
        return Message.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
          null,
        );
      }).toList();
    });
  }

  Future<void> requestNextPage() async {
    await _dynamicCollection.nextPage();
  }

  Future<void> dispose() async {
    await _dynamicCollection.dispose();
  }
}
