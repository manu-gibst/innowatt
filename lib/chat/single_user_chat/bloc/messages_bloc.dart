import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:innowatt/repository/chat_repository/chat_repository.dart';
import 'package:innowatt/repository/message_repository/message_repository.dart';
import 'package:innowatt/repository/message_repository/src/models/message.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc({required MessageRepository messageRepository})
      : _messageRepository = messageRepository,
        super(MessagesState()) {
    on<MessagesFetched>(_onFetched);
    on<MessageSent>(_onSent);
  }
  final MessageRepository _messageRepository;

  Future<void> _onFetched(
    MessagesFetched event,
    Emitter<MessagesState> emit,
  ) async {
    if (state.hasReachedMax) return;
    if (state.status == MessagesStatus.initial) {
      if (await _messageRepository.isMessagesEmpty) {
        return emit(state.copyWith(
          status: MessagesStatus.success,
          messages: [],
        ));
      }
    }
    emit(state.copyWith(status: MessagesStatus.loading));
    try {
      await emit.forEach(_messageRepository.messagesStream(),
          onData: (messages) {
        return state.copyWith(
          status: MessagesStatus.success,
          messages: messages,
          hasReachedMax: !_messageRepository.hasMoreChats,
        );
      });
    } catch (_) {
      emit(state.copyWith(status: MessagesStatus.failure));
    }
  }

  void _onSent(
    MessageSent event,
    Emitter<MessagesState> emit,
  ) {
    print('event.text: ${event.text}');
    _messageRepository.sendMessage(
      text: event.text,
      authorId: event.authorId,
      chatId: _messageRepository.chatId,
    );
  }
}
