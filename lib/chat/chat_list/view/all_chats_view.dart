import 'package:authentication_repository/authentication_repository.dart'
    hide User;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innowatt/chat/chat_form/view/single_user_form.dart';
import 'package:innowatt/repository/chat_repository/src/chat_repository.dart';
import 'package:innowatt/repository/chat_repository/src/models/chat.dart';

class AllChatsView extends StatefulWidget {
  const AllChatsView({super.key});

  @override
  State<AllChatsView> createState() => _AllChatsViewState();
}

class _AllChatsViewState extends State<AllChatsView> {
  @override
  Widget build(BuildContext context) {
    final chatRepository = ChatRepository();
    final currentUser = context.read<AuthenticationRepository>().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).push(SingleUserPopup<void>()),
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
  }
}
