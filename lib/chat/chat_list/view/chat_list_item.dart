import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:innowatt/app/router/routes.dart';
import 'package:innowatt/repository/chat_repository/src/models/chat.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(chat.name),
      subtitle: Text(chat.updatedTime!.date()),
      trailing: Text(chat.updatedTime!.time()),
      onTap: () {
        context.push(
          Routes.chatRoutes.singleUserChat(chatId: chat.chatId!),
          extra: chat.name,
        );
      },
    );
  }
}

extension on Timestamp {
  String date() {
    final date = toDate().toIso8601String().substring(0, 10);
    return date;
  }

  String time() {
    final date = toDate();
    return '${date.hour}:${date.minute}';
  }
}
