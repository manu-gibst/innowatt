part of 'messages_bloc.dart';

enum MessagesStatus { initial, loading, success, failure }

final class MessagesState extends Equatable {
  const MessagesState({
    this.chat = Chat.empty,
    this.messages,
    this.status = MessagesStatus.initial,
  });

  final Chat chat;
  final List<Message>? messages;
  final MessagesStatus status;

  MessagesState copyWith({
    Chat? chat,
    List<Message>? messages,
    MessagesStatus? status,
  }) {
    return MessagesState(
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        chat,
        messages,
        status,
      ];

  @override
  String toString() =>
      'MessageState { number of messages: ${messages?.length}, status: $status }';
}
