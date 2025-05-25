import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:innowatt/repository/chat_repository/src/chat_repository.dart';
import 'package:innowatt/repository/chat_repository/src/models/models.dart';
import 'package:stream_transform/stream_transform.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

final throttleDuration = Duration(milliseconds: 3000);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc({
    required ChatRepository chatRepository,
  })  : _chatRepository = chatRepository,
        super(ChatListState()) {
    on<ChatListSingleUserChatCreated>(_onSingleUserChatCreated);
    on<ChatListFetched>(
      _onFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final ChatRepository _chatRepository;

  void _onSingleUserChatCreated(
    ChatListSingleUserChatCreated event,
    Emitter<ChatListState> emit,
  ) {
    _chatRepository.createSingleUserChat(
      uid: event.uid,
      chatName: event.chatName,
    );
  }

  Future<void> _onFetched(
    ChatListFetched event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      await emit.forEach(
        _chatRepository.chatsStream(),
        onData: (chats) {
          return state.copyWith(
            status: ChatListStatus.success,
            chats: chats,
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(status: ChatListStatus.failure));
    }
  }

  @override
  Future<void> close() async {
    await _chatRepository.dispose();
    return super.close();
  }
}
