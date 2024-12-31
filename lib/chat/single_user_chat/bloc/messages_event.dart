part of 'messages_bloc.dart';

sealed class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

final class MessagesFetched extends MessagesEvent {}

final class MessageSent extends MessagesEvent {
  const MessageSent({
    required this.text,
    required this.authorId,
  });

  final String text;
  final String authorId;

  @override
  List<Object> get props => [text, authorId];
}
