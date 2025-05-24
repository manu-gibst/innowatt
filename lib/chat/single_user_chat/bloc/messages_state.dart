part of 'messages_bloc.dart';

enum MessagesStatus { initial, loading, success, failure }

final class MessagesState extends Equatable {
  const MessagesState({
    this.chat = Chat.empty,
    this.messages,
    this.status = MessagesStatus.initial,
    this.hasReachedMax = false,
  });

  final Chat chat;
  final List<Message>? messages;
  final MessagesStatus status;
  final bool hasReachedMax;

  MessagesState copyWith({
    Chat? chat,
    List<Message>? messages,
    MessagesStatus? status,
    bool? hasReachedMax,
  }) {
    return MessagesState(
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        chat,
        messages,
        status,
        hasReachedMax,
      ];

  @override
  String toString() =>
      'MessageState { number of messages: ${messages?.length}, status: $status, hasReachedMax: $hasReachedMax }';
}
