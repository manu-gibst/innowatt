import 'dart:async';

import 'package:firestore_collection/firestore_collection.dart';
import 'package:innowatt/repository/chat_repository/src/exceptions/exception.dart';
import 'package:innowatt/repository/chat_repository/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  ChatRepository({required String uid})
      : _dynamicCollection = FirestoreCollection(
          collection: FirebaseFirestore.instance.collection('chats'),
          initializeOnStart: true,
          pageSize: 20,
          serverOnly: false,
          live: true,
          queryList: [
            FirebaseFirestore.instance
                .collection('chats')
                .where("uids", arrayContains: uid)
          ],
          queryOrder: QueryOrder(orderField: 'updated_time'),
        );
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

  final FirestoreCollection _dynamicCollection;

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

  Stream<List<Chat>> chatsStream() {
    return _dynamicCollection.stream.map((snapshots) {
      if (snapshots == null || snapshots.isEmpty) return <Chat>[];
      return snapshots.map((doc) {
        return Chat.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
          null,
        );
      }).toList();
    });
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

  Future<void> updateCreatedTime({required String chatId}) async {
    await _chatsCollection
        .doc(chatId)
        .update({'updated_time': Timestamp.now()});
  }

  Future<void> dispose() async {}
}
