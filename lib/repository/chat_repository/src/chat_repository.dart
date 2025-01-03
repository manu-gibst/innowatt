import 'dart:async';

import 'package:innowatt/repository/chat_repository/src/exceptions/exception.dart';
import 'package:innowatt/repository/chat_repository/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final _users = FirebaseFirestore.instance.collection('users').withConverter(
        fromFirestore: User.fromFirestore,
        toFirestore: (User user, _) => user.toFirestore(),
      );
  final _chats = FirebaseFirestore.instance.collection('chats').withConverter(
        fromFirestore: Chat.fromFirestore,
        toFirestore: (Chat chat, _) => chat.toFirestore(),
      );

  final StreamController<List<Chat>> _chatsController =
      StreamController<List<Chat>>.broadcast();

  bool _hasMoreChats = true;
  DocumentSnapshot<Chat>? _lastDocument;
  final List<List<Chat>> _allPagedChats = [];

  bool get hasMoreChats => _hasMoreChats;

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
      throw FirestoreDatabaseFailure.fromCode(e.code);
    } catch (_) {
      throw FirestoreDatabaseFailure();
    }
  }

  void requestChats({required String uid}) {
    var pageChatsQuery = _chats
        .where("uids", arrayContains: uid)
        .orderBy('updated_time', descending: true)
        .limit(20);
    if (_lastDocument != null) {
      pageChatsQuery = pageChatsQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreChats) return;

    var currentRequestIndex = _allPagedChats.length;

    pageChatsQuery.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final chats = snapshot.docs.map((e) => e.data()).toList();

        final pageExists = currentRequestIndex < _allPagedChats.length;

        if (pageExists) {
          _allPagedChats[currentRequestIndex] = chats;
        } else {
          _allPagedChats.add(chats);
        }
        final allChats = _allPagedChats.fold<List<Chat>>(
          <Chat>[],
          (initialValue, pageItems) => initialValue..addAll(pageItems),
        );
        _chatsController.add(allChats);

        if (currentRequestIndex == _allPagedChats.length - 1) {
          _lastDocument = snapshot.docs.last;
        }

        _hasMoreChats = chats.length == 20;
      }
    });
  }

  Stream<List<Chat>> chatsStream({required String uid}) {
    requestChats(uid: uid);
    return _chatsController.stream;
  }

  Future<Chat> getChat({required String chatId}) async {
    try {
      final doc = await _chats.doc(chatId).get();
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
        await _chats.where("uids", arrayContains: uid).limit(1).get();
    return querySnapshot.docs.isEmpty;
  }

  void updateCreatedTime({required String chatId}) {
    _chats.doc(chatId).update({'updated_time': Timestamp.now()});
  }
}
