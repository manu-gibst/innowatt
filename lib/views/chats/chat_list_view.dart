import 'package:flutter/material.dart';
import 'package:innowatt/components/text.dart';
import 'package:innowatt/services/cloud/cloud_chat.dart';
// import 'package:innowatt/utilities/dialogs/delete_dialog.dart';

typedef ChatCallback = void Function(CloudChat chat);

class ChatsListView extends StatelessWidget {
  final Iterable<CloudChat> chats;
  final ChatCallback onTap;

  const ChatsListView({
    super.key,
    required this.chats,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final individualChat = chats.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(individualChat);
          },
          title: MyText(
            text: individualChat.name,
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 20,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          leading: Icon(
            Icons.account_circle_outlined,
            color: Theme.of(context).colorScheme.secondary,
            size: 40,
          ),
        );
      },
    );
  }
}
