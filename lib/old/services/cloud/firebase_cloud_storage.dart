import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innowatt/old/services/cloud/cloud_chat.dart';
import 'package:innowatt/old/services/cloud/cloud_expections.dart';
import 'package:innowatt/old/services/cloud/cloud_storage_constants.dart';
import 'package:innowatt/old/services/cloud/cloud_storage_exceptions.dart';
import 'package:innowatt/old/services/cloud/messages/cloud_message.dart';

class FirebaseCloudStorage {
  FirebaseCloudStorage._privateConstructor() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      firebaseUser = user;
    });
  }
  static final FirebaseCloudStorage instance =
      FirebaseCloudStorage._privateConstructor();

  final chats = FirebaseFirestore.instance.collection('chats');
  final messages = FirebaseFirestore.instance.collection('messages');
  final users = FirebaseFirestore.instance.collection('users');

  User? firebaseUser = FirebaseAuth.instance.currentUser;

  // FUNCTIONS FOR USERS ------------------------------------------ idrk why i need it

  Future<void> addCloudUser({
    required String id,
    required String email,
    required String password,
  }) async {
    await users.doc(id).set({
      emailFieldName: email,
      passwordFieldName: password,
    });
  }

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return users.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individial user
        final user = doc.data();
        return user;
      }).toList();
    });
  }

// IVE STOPPED HERE ----------------------------------------------- idrk why i need it
  Stream<Iterable<CloudChat>> allUsers({required String ownerUserId}) =>
      chats.snapshots().map((event) => event.docs
          .map((doc) => CloudChat.fromSnapshot(doc))
          .where((chat) => chat.userIds == ownerUserId));

  // FUNCTIONS FOR MESSAGES ---------------------------------------

  Future<CloudMessage> createNewMessage({
    required String ownerUserId,
    required String text,
    required int createdAt,
  }) async {
    final document = await chats.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: text,
    });
    final fetchedMessage = await document.get();
    return CloudMessage(
      documentId: fetchedMessage.id,
      ownerUserId: ownerUserId,
      createdAt: createdAt,
      text: text,
    );
  }

  Future<void> deleteChat({required String documentId}) async {
    try {
      await chats.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateChat({
    required String documentId,
    required String name,
  }) async {
    try {
      await chats.doc(documentId).update({nameFieldName: name});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudChat>> allChats() {
    final fu = firebaseUser;

    if (fu == null) return const Stream.empty();

    final collection = chats.where(
      userIdsFieldName,
      arrayContains: fu,
    );

    return chats.snapshots().map((event) => event.docs
        .map((doc) => CloudChat.fromSnapshot(doc))
        .where((chat) => chat.userIds == fu));
  }

  Future<Iterable<CloudChat>> getChats({required String ownerUserId}) async {
    try {
      return await chats
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudChat.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  // --------------------------------------------------------------------------------------
  // Future<CloudChat> createGroupChat FOR MULTIPLE USERS =================== LATER
  // --------------------------------------------------------------------------------------

  Future<CloudChat> createIndividualChat({
    required String name,
  }) async {
    final fu = firebaseUser;

    if (fu == null) return Future.error('User does not exist');
    final userIds = [fu.uid];

    try {
      final document = await chats.add({
        userIdsFieldName: [userIds],
        nameFieldName: name,
      });
      final fetchedChat = await document.get();
      return CloudChat(
        documentId: fetchedChat.id,
        userIds: userIds,
        name: name,
      );
    } catch (e) {
      if (name.isEmpty) {
        throw FieldsAreEmptyException();
      } else {
        throw GenericException();
      }
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
