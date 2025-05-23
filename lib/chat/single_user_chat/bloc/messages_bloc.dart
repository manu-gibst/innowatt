import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:innowatt/repository/chat_repository/chat_repository.dart';
import 'package:innowatt/repository/message_repository/message_repository.dart';
import 'package:innowatt/repository/message_repository/src/models/message.dart';
import 'package:stream_transform/stream_transform.dart';

part 'messages_event.dart';
part 'messages_state.dart';

final throttleDuration = Duration(milliseconds: 3000);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc(
      {required MessageRepository messageRepository,
      required ChatRepository chatRepository})
      : _messageRepository = messageRepository,
        _chatRepository = chatRepository,
        super(MessagesState()) {
    on<MessagesFetched>(
      _onFetched,
      // transformer: throttleDroppable(throttleDuration),
    );
    on<MessageSent>(_onSent);
  }

  final MessageRepository _messageRepository;
  final ChatRepository _chatRepository;

  Future<void> _onFetched(
    MessagesFetched event,
    Emitter<MessagesState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      await emit.forEach(
          _messageRepository.messagesStream(loadOnlyNew: event.loadOnlyNew),
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
    _messageRepository.sendMessage(
      text: event.text,
      authorId: event.authorId,
      chatId: _messageRepository.chatId,
    );
    _chatRepository.updateCreatedTime(chatId: _messageRepository.chatId);
  }

  @override
  Future<void> close() async {
    await _messageRepository.dispose();
    await _chatRepository.dispose();
    return super.close();
  }
}
