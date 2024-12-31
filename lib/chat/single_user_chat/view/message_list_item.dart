import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innowatt/repository/message_repository/src/models/models.dart';

class MessageListItem extends StatelessWidget {
  const MessageListItem({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(message.text),
      subtitle: Text(message.authorId),
      leading: Text(message.createdAt.time()),
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
