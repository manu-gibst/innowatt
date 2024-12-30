import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:innowatt/repository/chat_repository/src/chat_repository.dart';

part 'chat_form_state.dart';

class ChatFormCubit extends Cubit<ChatFormState> {
  ChatFormCubit({
    required ChatRepository chatRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _chatRepository = chatRepository,
        _authenticationRepository = authenticationRepository,
        super(const ChatFormState());

  final ChatRepository _chatRepository;
  final AuthenticationRepository _authenticationRepository;

  void chatNameChanged(String value) {
    final chatName = ChatName.dirty(value);
    emit(state.copyWith(
      chatName: chatName,
      isValid: Formz.validate([chatName]),
    ));
  }

  void formSubmitted() {
    final uid = _authenticationRepository.currentUser.id;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      _chatRepository.createSingleUserChat(
        uid: uid,
        chatName: state.chatName.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
