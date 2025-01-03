import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innowatt/chat/single_user_chat/view/chat_list_builder.dart';
import 'package:innowatt/repository/message_repository/src/models/message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _MessagesBuilder(),
    );
  }
}

List<Message> messages = [
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2024-12-31 23:59')),
    text: 'Omg soon its gonna be New Year',
  ),
  Message(
    authorId: 'otherId',
    createdAt: Timestamp.fromDate(DateTime.parse('2024-12-31 23:59:30')),
    text: 'no one cares',
  ),
  Message(
    authorId: 'otherId',
    createdAt: Timestamp.fromDate(DateTime.parse('2024-12-31 23:59:32')),
    text: 'shut up',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2024-12-31 23:59:49')),
    text: 'Why are you so mean',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01')),
    text: 'Yayyyy',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 00:00:02')),
    text: 'Happy new year!!!',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:03:00')),
    text: 'Why are you ignoring me',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:04:00')),
    text: ';(',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:04:30')),
    text: 'i hate you',
  ),
  Message(
    authorId: 'otherId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:05:00')),
    text: 'sorry i was sleeping',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:06:30')),
    text: 'such a liar',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:06:30')),
    text: 'such a liar!',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:06:30')),
    text: 'im tired of you',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:06:30')),
    text: 'we are breaking up',
  ),
  Message(
    authorId: 'otherId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:06:30')),
    text: 'bro you know that we are just friends right',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:06:30')),
    text: 'so for you its just casual?',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:06:30')),
    text: 'enought of it already',
  ),
  Message(
    authorId: 'authorId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:06:30')),
    text: 'bye',
  ),
  Message(
    authorId: 'otherId',
    createdAt: Timestamp.fromDate(DateTime.parse('2025-01-01 01:06:30')),
    text: 'T_T',
  ),
];

class _MessagesBuilder extends StatelessWidget {
  _MessagesBuilder({
    ScrollController? scrollController,
  }) : _scrollController = scrollController;

  final ScrollController? _scrollController;

  final newmessages = messages.reversed.toList();

  @override
  Widget build(BuildContext context) {
    return ChatListBuilder(
      messages: newmessages,
      currentUserId: 'authorId',
      scrollController: _scrollController ?? ScrollController(),
    );
  }
}
