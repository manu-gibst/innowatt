part of 'messages_bloc.dart';

enum MessagesStatus { initial, loading, success, failure }

final class MessagesState extends Equatable {
  const MessagesState({
    this.chat = Chat.empty,
    this.messages,
    this.status = MessagesStatus.initial,
    this.waitingReponse = false,
    this.generatingMessage,
  });

  final Chat chat;
  final List<Message>? messages;
  final MessagesStatus status;
  final bool waitingReponse;
  final Message? generatingMessage;

  MessagesState copyWith({
    Chat? chat,
    List<Message>? messages,
    MessagesStatus? status,
    bool? waitingReponse,
    Object? generatingMessage = _noValue,
  }) {
    return MessagesState(
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      waitingReponse: waitingReponse ?? this.waitingReponse,
      generatingMessage: generatingMessage == _noValue
          ? this.generatingMessage
          : generatingMessage as Message?,
    );
  }

  static const _noValue = Object();

  @override
  List<Object?> get props => [
        chat,
        messages,
        status,
        waitingReponse,
        generatingMessage,
      ];

  @override
  String toString() =>
      'MessageState { number of messages: ${messages?.length}, status: $status, generatingMessage: $generatingMessage }';
}
