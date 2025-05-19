import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    final theme = Theme.of(context);
    return ListTile(
      title: Text(chat.name),
      leading: FaIcon(FontAwesomeIcons.solidCircleUser, size: 36),
      trailing: Text(
        _getTimeOrDay(chat.updatedTime!),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: () {
        context.push(
          Routes.chatRoutes.singleUserChat(chatId: chat.chatId!),
          extra: chat.name,
        );
      },
    );
  }
}

String _getTimeOrDay(Timestamp timestamp) {
  final currentTime = DateTime.now();
  final time = timestamp.toDate();
  final difference = time.difference(currentTime).inDays.abs();
  // Check if [timestamp] was on the same day
  if (currentTime.day == time.day) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
  // Check if [timestamp] was earliear or on Monday
  if (difference < 7 && time.weekday < currentTime.weekday) {
    return _weekDays[time.weekday - 1];
  }
  // Return month
  return '${_months[time.month - 1]} ${time.day}';
}

const _weekDays = [
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun",
];

const _months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];
