part of 'chat_list_bloc.dart';

enum ChatListStatus { initial, loading, success, failure }

final class ChatListState extends Equatable {
  const ChatListState({
    this.chats = const [],
    this.status = ChatListStatus.initial,
  });

  final List<Chat> chats;
  final ChatListStatus status;

  @override
  List<Object> get props => [chats, status];

  ChatListState copyWith({
    List<Chat>? chats,
    ChatListStatus? status,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'ChatListState { number of chats:${chats.length}, status: $status }';
  }
}
