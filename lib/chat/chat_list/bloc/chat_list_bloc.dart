import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:innowatt/repository/chat_repository/src/chat_repository.dart';
import 'package:innowatt/repository/chat_repository/src/models/models.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChatListInitial()) {
    on<ChatListSingleUserChatCreated>(_onSingleUserChatCreated);
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
}
