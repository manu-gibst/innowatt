import 'dart:math';

import 'package:ai_repository/ai_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:innowatt/repository/chat_repository/chat_repository.dart';
import 'package:innowatt/repository/message_repository/message_repository.dart';
import 'package:innowatt/repository/message_repository/src/models/message.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:uuid/uuid.dart';

part 'messages_event.dart';
part 'messages_state.dart';

final throttleDuration = Duration(milliseconds: 3000);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc({
    required MessageRepository messageRepository,
    required ChatRepository chatRepository,
    required AiRepository aiRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _messageRepository = messageRepository,
        _chatRepository = chatRepository,
        _aiRepository = aiRepository,
        _authenticationRepository = authenticationRepository,
        super(MessagesState()) {
    on<MessagesFetched>(
      _onFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<MessageSent>(_onSent);
    on<MessagesNextPageRequested>(_onNextPageRequested);
  }

  final MessageRepository _messageRepository;
  final ChatRepository _chatRepository;
  final AiRepository _aiRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<void> _onFetched(
    MessagesFetched event,
    Emitter<MessagesState> emit,
  ) async {
    try {
      return emit.forEach(_messageRepository.getMessageStream(),
          onData: (data) {
        bool foundDuplicate = false;
        if (state.generatingMessage != null) {
          for (int i = 0; i < data.length; i++) {
            if (data[i].id == state.generatingMessage!.id) {
              foundDuplicate = true;
            }
          }
        }
        return state.copyWith(
          status: MessagesStatus.success,
          messages: data,
          generatingMessage: foundDuplicate ? null : state.generatingMessage,
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

  Future<void> _onSent(
    MessageSent event,
    Emitter<MessagesState> emit,
  ) async {
    final userToken = await _authenticationRepository.getIdToken();
    try {
      // Persisting User's message
      await _messageRepository.sendMessage(
        text: event.text,
        authorId: event.authorId,
        chatId: _messageRepository.chatId,
      );
      await _chatRepository.updateCreatedTime(
        chatId: _messageRepository.chatId,
      );
      print("User's message sent to server");

      // Adding a blank Message to append chunks from the stream
      emit(state.copyWith(
        waitingReponse: true,
        generatingMessage: Message(
          id: Uuid().v1(),
          authorId: 'bot_id',
          createdAt: Timestamp.now(),
          text: '',
        ),
      ));
      print('generatingMessage created');
      final stream = _aiRepository.streamResponse(
        userToken: userToken!,
        chatId: _messageRepository.chatId,
        query: event.text,
        lastMessages: state.messages!.basicJsonList(),
      );
      await emit.forEach(
        stream,
        onData: (chunk) {
          final generatingMessage = state.generatingMessage!.changeText(
            '${state.generatingMessage!.text}$chunk\n',
          );
          return state.copyWith(generatingMessage: generatingMessage);
        },
      );
      print("generatingMessage completed = ${state.generatingMessage!.text}");

      await _messageRepository.sendMessage(
        id: state.generatingMessage!.id,
        text: state.generatingMessage!.text,
        authorId: 'bot_id',
        chatId: _messageRepository.chatId,
      );
      emit(state.copyWith(waitingReponse: false, generatingMessage: null));
      await _chatRepository.updateCreatedTime(
        chatId: _messageRepository.chatId,
      );
      print("generated Message persisted to server");
    } catch (e) {
      print(e);
      emit(state.copyWith(status: MessagesStatus.failure));
    }
  }

  @override
  Future<void> close() async {
    await _messageRepository.dispose();
    await _chatRepository.dispose();
    return super.close();
  }
}

extension on List<Message> {
  List<Map<String, dynamic>> basicJsonList() {
    return map((e) => e.toBasicJson()).toList().sublist(1, min(10, length));
  }
}
