import 'package:authentication_repository/authentication_repository.dart'
    hide User;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innowatt/chat/chat_form/view/single_user_form.dart';
import 'package:innowatt/chat/chat_list/bloc/chat_list_bloc.dart';
import 'package:innowatt/chat/chat_list/view/chat_list_item.dart';
import 'package:innowatt/core/widgets/error_card.dart';
import 'package:innowatt/repository/chat_repository/src/chat_repository.dart';

class AllChatsScreen extends StatelessWidget {
  const AllChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationRepository>().currentUser.id;
    return BlocProvider(
      lazy: false,
      create: (context) => ChatListBloc(
        chatRepository: ChatRepository(uid: uid),
      )..add(ChatListFetched(loadOnlyNew: true)),
      child: const AllChatsView(),
    );
  }
}

class AllChatsView extends StatefulWidget {
  const AllChatsView({super.key});

  @override
  State<AllChatsView> createState() => _AllChatsViewState();
}

class _AllChatsViewState extends State<AllChatsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          switch (state.status) {
            case ChatListStatus.initial:
            case ChatListStatus.loading:
              return Center(child: CircularProgressIndicator());
            case ChatListStatus.failure:
              return ErrorCard();
            case ChatListStatus.success:
              final chats = state.chats;
              if (chats.isEmpty) {
                return _EmptyChatsView();
              }
              return ListView.separated(
                itemBuilder: (context, index) {
                  return ChatListItem(
                      key: Key("__${chats[index].chatId}_chatTileKey__"),
                      chat: chats[index]);
                },
                itemCount: chats.length,
                separatorBuilder: (context, index) => Divider(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                controller: _scrollController,
              );
          }
        },
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ChatListBloc>().add(ChatListFetched(loadOnlyNew: false));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _EmptyChatsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('You have no chats'),
          TextButton(
            onPressed: () =>
                Navigator.of(context).push(SingleUserPopup<void>()),
            child: const Text('Click here to create chat'),
          ),
        ],
      ),
    );
  }
}
