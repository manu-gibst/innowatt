import 'package:flutter/material.dart';
import 'package:innowatt/chat/single_user_chat/view/message_bubble.dart';
import 'package:innowatt/repository/message_repository/src/models/message.dart';

class ChatListBuilder extends StatelessWidget {
  const ChatListBuilder({
    super.key,
    required this.messages,
    required this.currentUserId,
    this.scrollController,
  });

  final List<Message> messages;
  final String currentUserId;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return _WidgetWithShaders(
      widget: ListView.separated(
        controller: scrollController,
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return MessageBubble(
            key: Key('__${messages[index].id!}_messageBubbleKey__'),
            message: messages[index],
            prevDifferent: messages[index].isDifferent(
                index < messages.length - 1 ? messages[index + 1] : null),
            nextDifferent: messages[index]
                .isDifferent(index > 0 ? messages[index - 1] : null),
            messageAlignment: messages[index].authorId == currentUserId
                ? MessageAlignment.right
                : MessageAlignment.left,
          );
        },
        separatorBuilder: (context, index) {
          if (messages[index].isDifferentDay(messages[index + 1])) {
            final date = messages[index + 1].createdAt.toDate();
            return Center(
              child: Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Text(date.toMonthAndDay),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class _WidgetWithShaders extends StatelessWidget {
  const _WidgetWithShaders({required this.widget});
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        final colorScheme = Theme.of(context).colorScheme;
        return LinearGradient(
          colors: [
            colorScheme.primaryFixedDim.brighten(0.8),
            Colors.white,
            Colors.white,
            colorScheme.primaryFixedDim.brighten(0.9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0,
            0.1,
            0.4,
            1,
          ],
        ).createShader(bounds);
      },
      child: widget,
    );
  }
}

extension on DateTime {
  String get toMonthAndDay {
    final monthName = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return '${monthName[month - 1]} $day';
  }
}

extension on Color {
  Color brighten(double x) {
    return HSLColor.fromColor(this).withLightness(x).toColor();
  }
}
