part of 'chat_list_bloc.dart';

enum ChatListStatus { initial, loading, success, failure }

final class ChatListState extends Equatable {
  const ChatListState({
    this.chats = const [],
    this.hasReachedMax = false,
    this.status = ChatListStatus.initial,
  });

  final List<Chat> chats;
  final bool hasReachedMax;
  final ChatListStatus status;

  @override
  List<Object> get props => [chats, hasReachedMax, status];

  ChatListState copyWith({
    List<Chat>? chats,
    bool? hasReachedMax,
    ChatListStatus? status,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'ChatListState { number of chats:${chats.length}, hasReachedMax: $hasReachedMax, status: $status }';
  }
}
