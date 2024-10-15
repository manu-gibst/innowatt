import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innowatt/components/button.dart';
import 'package:innowatt/components/spacings.dart';
import 'package:innowatt/components/text_field.dart';
import 'package:innowatt/services/cloud/chat/firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:innowatt/views/chats/chat_view.dart';

class CreateNewChat extends StatefulWidget {
  const CreateNewChat({super.key});

  @override
  State<CreateNewChat> createState() => _CreateNewChatState();
}

class _CreateNewChatState extends State<CreateNewChat> {
  late final TextEditingController _title;

  @override
  void initState() {
    _title = TextEditingController();

    super.initState();
  }

  void _handlePressed(types.User otherUser, BuildContext context) async {
    final navigator = Navigator.of(context);
    final room = await FirebaseChatCore.instance.createRoom(otherUser);
    await FirebaseFirestore.instance.collection('users').doc('ai-bot').set({
      "firstName": "innowatt",
      "imageUrl": null,
      "role": "bot",
    });

    navigator.pop();
    await navigator.push(
      MaterialPageRoute(
        builder: (context) => ChatView(
          room: room,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            MyTextField(controller: _title, hintText: "title"),
            addVerticalSpace(10),
            MyButton(
              onPressed: () => _handlePressed(
                FirebaseChatCore.instance.aiBotUser,
                context,
              ),
              text: "Create",
            ),
          ],
        ),
      ),
    );
  }
}
