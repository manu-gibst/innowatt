import 'package:innowatt/repository/chat_repository/src/exceptions/exception.dart';
import 'package:innowatt/repository/chat_repository/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  // final _database = FirebaseFirestore.instance;
  final _users = FirebaseFirestore.instance.collection('users').withConverter(
        fromFirestore: User.fromFirestore,
        toFirestore: (User user, _) => user.toFirestore(),
      );
  final _chats = FirebaseFirestore.instance.collection("chats").withConverter(
        fromFirestore: Chat.fromFirestore,
        toFirestore: (Chat chat, _) => chat.toFirestore(),
      );

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
      _users.doc(user.uid).set(user);
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
      _chats.doc().set(chat);
    } on FirebaseException catch (e) {
      print('#DEBUG IN [createSingleUserChat]#: ERROR(${e.code}): $e');
      throw FirestoreDatabaseFailure.fromCode(e.code);
    } catch (_) {
      throw FirestoreDatabaseFailure();
    }
  }

  Stream<List<Chat>> streamOfAllChats({required String uid}) {
    print('#DEBUG IN# streamOfAllChats');
    try {
      final streamSnaps = _chats
          .where("uids", arrayContains: uid)
          .orderBy('updated_time', descending: true)
          .limit(5)
          .snapshots();
      return streamSnaps.map((event) {
        return event.docs.map((e) => e.data()).toList();
      });
    } on FirebaseException catch (e) {
      print('#DEBUG IN [streamOfAllChats]#: ERROR(${e.code}): $e');
      throw FirestoreDatabaseFailure.fromCode(e.code);
    } catch (_) {
      throw FirestoreDatabaseFailure();
    }
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
      final messages = _getMessages(chatId: chatId);
      messages.doc().set(message);
    } on FirebaseException catch (e) {
      print('#DEBUG IN [sendMessage]#: ERROR(${e.code}): $e');
      throw FirestoreDatabaseFailure.fromCode(e.code);
    } catch (_) {
      throw FirestoreDatabaseFailure();
    }
  }

  Stream<List<Message>> streamOfMessages({required String chatId}) {
    final queryMessages = _getMessages(chatId: chatId)
        .orderBy('created_at', descending: true)
        .limit(10)
        .snapshots();
    return queryMessages.map((event) {
      return event.docs.map((e) => e.data()).toList();
    });
  }

  CollectionReference<Message> _getMessages({required String chatId}) {
    return _chats.doc(chatId).collection('messages').withConverter(
          fromFirestore: Message.fromFirestore,
          toFirestore: (Message message, _) => message.toFirestore(),
        );
  }
}
