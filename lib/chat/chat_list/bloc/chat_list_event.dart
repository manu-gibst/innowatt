part of 'chat_list_bloc.dart';

sealed class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object> get props => [];
}

final class ChatListSingleUserChatCreated extends ChatListEvent {
  const ChatListSingleUserChatCreated({
    required this.uid,
    required this.chatName,
  });

  final String uid;
  final String chatName;
  @override
  List<Object> get props => [uid, chatName];
}

final class ChatListFetched extends ChatListEvent {
  const ChatListFetched({this.loadOnlyNew = false});
  final bool loadOnlyNew;
}
