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
      (event, emit) async {
        print("MessagesFetched() called");
        await _onFetched(event, emit);
      },
      transformer: throttleDroppable(throttleDuration),
    );
    on<MessageSent>(_onSent);
    on<MessagesNextPageRequested>(_onNextPageRequested);
  }

  final MessageRepository _messageRepository;
  final ChatRepository _chatRepository;

  Future<void> _onFetched(
    MessagesFetched event,
    Emitter<MessagesState> emit,
  ) async {
    try {
      return emit.forEach(_messageRepository.getMessageStream(),
          onData: (data) {
        return state.copyWith(
          status: MessagesStatus.success,
          messages: data,
        );
      });
    } catch (e) {
      print("Error during fetching messages: $e");
      emit(state.copyWith(status: MessagesStatus.failure));
    }
  }

  void _onNextPageRequested(
    MessagesNextPageRequested event,
    Emitter<MessagesState> emit,
  ) {
    _messageRepository.requestNextPage();
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
