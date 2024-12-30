import 'package:authentication_repository/authentication_repository.dart'
    hide User;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:go_router/go_router.dart';
import 'package:innowatt/app/router/routes.dart';
import 'package:innowatt/old/components/text.dart';
import 'package:innowatt/old/services/cloud/chat/firebase_chat_core.dart';
import 'package:innowatt/old/services/cloud/chat/util_getters.dart';
import 'package:innowatt/chat/chat_list/view/chat_view.dart';
import 'package:innowatt/repository/chat_repository/src/chat_repository.dart';
import 'package:innowatt/repository/chat_repository/src/models/chat.dart';

class AllChatsView extends StatefulWidget {
  const AllChatsView({super.key});

  @override
  State<AllChatsView> createState() => _AllChatsViewState();
}

class _AllChatsViewState extends State<AllChatsView> {
  bool _error = false;
  bool _initialized = false;
  User? _user;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatRepository = ChatRepository();
    final currentUser = context.read<AuthenticationRepository>().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            onPressed: () => chatRepository.createSingleUserChat(
              uid: currentUser.id,
              chatName: 'temp; ${DateTime.now().second}',
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<Chat>>(
        stream: chatRepository.streamOfAllChats(uid: currentUser.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.map(
                (chat) {
                  return ListTile(
                    title: Text(chat.name),
                    subtitle: Text(
                        '${chat.updatedTime.toDate().hour}:${chat.updatedTime.toDate().minute.toString().padLeft(2, '0')}'),
                  );
                },
              ).toList(),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );

    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: MyText(
          text: "Chats",
          color: Theme.of(context).colorScheme.tertiary,
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push(Routes.chatRoutes.createNew);
            },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<types.Room>>(
        stream: FirebaseChatCore.instance.rooms(),
        initialData: const [],
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final room = snapshot.data![index];
                    print('##DEBUG##: $room');

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatView(
                              room: room,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            _buildAvatar(room),
                            Text(room.name ?? ''),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    bottom: 200,
                  ),
                  child: const Text('No rooms'),
                );
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
