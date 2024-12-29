import 'package:firebase_database/firebase_database.dart';
import 'package:innowatt/repository/chat_repository/src/models/models.dart';

class ChatRepository {
  final _users = FirebaseDatabase.instance.ref("users");
  final _chats = FirebaseDatabase.instance.ref("chats");

  void addUser({required String uid}) {
    DatabaseReference newUser = _users.push();
    final user = User(uid: uid);
    newUser.set(user.toJson());
  }

  void createIndividualChat({required String uid, required String roomName}) {
    print("#DEBUG IN# createIndividualChat");
    try {
      DatabaseReference newChat = _chats.push();
      final chat = Chat(name: roomName, uids: [uid]);
      newChat.set(chat.toJson());
    } catch (e) {
      print("#ERROR# ${e.toString()}");
    }
  }

  void streamOfAllChats({required String uid}) {
    print('#DEBUG IN# streamOfAllChats');
    _chats.onValue.map((event) =>
        print('#DEBUG# {event.snapshot.value}: ${event.snapshot.value}'));
  }
}
