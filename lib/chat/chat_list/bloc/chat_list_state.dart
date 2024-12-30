part of 'chat_list_bloc.dart';

sealed class ChatListState extends Equatable {
  const ChatListState({
    this.chats = const [],
    this.hasReachedMax = false,
  });

  final List<Chat> chats;
  final bool hasReachedMax;

  @override
  List<Object> get props => [chats, hasReachedMax];

  @override
  String toString() {
    return 'ChatListState { chats:$chats, hasReachedMax: $hasReachedMax }';
  }
}

final class ChatListInitial extends ChatListState {
  @override
  String toString() {
    return 'ChatListInitial { chats:$chats, hasReachedMax: $hasReachedMax }';
  }
}

final class ChatListLoading extends ChatListState {
  @override
  String toString() {
    return 'ChatListLoading { chats:$chats, hasReachedMax: $hasReachedMax }';
  }
}

final class ChatListPopulated extends ChatListState {
  @override
  String toString() {
    return 'ChatListPopulated { chats:$chats, hasReachedMax: $hasReachedMax }';
  }
}
