import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.sender});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          child: Text(sender[0]),
        ),
        Expanded(
          child: Column(
            children: [Text(sender), Text(text)],
          ),
        )
      ],
    );
  }
}
