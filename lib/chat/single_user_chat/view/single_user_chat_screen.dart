import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innowatt/chat/single_user_chat/bloc/messages_bloc.dart';
import 'package:innowatt/chat/single_user_chat/view/chat_list_builder.dart';
import 'package:innowatt/core/widgets/error_card.dart';
import 'package:innowatt/repository/chat_repository/src/chat_repository.dart';
import 'package:innowatt/repository/message_repository/message_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleUserChatScreen extends StatefulWidget {
  const SingleUserChatScreen({
    super.key,
    required this.chatId,
    required this.chatName,
  });

  final String chatId;
  final String chatName;

  @override
  State<SingleUserChatScreen> createState() => _SingleUserChatScreenState();
}

class _SingleUserChatScreenState extends State<SingleUserChatScreen> {
  late final SharedPreferences _prefs;
  bool _isLoading = true;

  @override
  void initState() {
    _initPrefs();
    super.initState();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const CircularProgressIndicator();
    return BlocProvider(
      lazy: false,
      create: (context) => MessagesBloc(
        messageRepository: MessageRepository(
          chatId: widget.chatId,
          prefs: _prefs,
        ),
        chatRepository: ChatRepository(),
      )..add(MessagesFetched()),
      child: SingleUserChatView(
        chatId: widget.chatId,
        chatName: widget.chatName,
      ),
    );
  }
}

class SingleUserChatView extends StatefulWidget {
  const SingleUserChatView({
    super.key,
    required this.chatId,
    required this.chatName,
  });

  final String chatId;
  final String chatName;

  @override
  State<SingleUserChatView> createState() => _SingleUserChatViewState();
}

class _SingleUserChatViewState extends State<SingleUserChatView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName),
      ),
      body: Column(
        children: [
          Expanded(
            child: _MessagesBuilder(scrollController: _scrollController),
          ),
          _buildSendContainer(context),
        ],
      ),
    );
  }

  Align _buildSendContainer(BuildContext context) {
    return Align(
      alignment: Alignment(0, 1),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Send Message',
                  contentPadding: EdgeInsets.only(left: 10),
                ),
                textCapitalization: TextCapitalization.sentences,
                controller: _messageController,
                onSubmitted: (value) => _sendMessage,
              ),
            ),
            IconButton(
              onPressed: _sendMessage,
              icon: Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;
    context.read<MessagesBloc>().add(
          MessageSent(
            text: _messageController.text,
            authorId: context.read<AuthenticationRepository>().currentUser.id,
          ),
        );
    _messageController.clear();
  }

  void _onScroll() {
    if (_isTop) {
      context.read<MessagesBloc>().add(MessagesNextPageRequested());
    }
  }

  bool get _isTop {
    if (!_scrollController.hasClients) return false;
    final currentScroll = _scrollController.offset;
    return currentScroll <= 50;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

class _MessagesBuilder extends StatelessWidget {
  const _MessagesBuilder({
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesBloc, MessagesState>(
      builder: (context, state) {
        switch (state.status) {
          case MessagesStatus.initial:
          case MessagesStatus.loading:
            return Center(child: CircularProgressIndicator());
          case MessagesStatus.failure:
            return ErrorCard();
          case MessagesStatus.success:
            final messages = state.messages;
            if (messages != null && messages.isEmpty) {
              return _EmptyMessagesView();
            }
            return ChatListBuilder(
              messages: messages!,
              currentUserId:
                  context.read<AuthenticationRepository>().currentUser.id,
              scrollController: _scrollController,
            );
        }
      },
    );
  }
}

class _EmptyMessagesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment(0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your chat is empty'),
              Text('Send a message'),
            ],
          ),
        ),
      ],
    );
  }
}
