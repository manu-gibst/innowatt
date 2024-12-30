part of 'chat_form_cubit.dart';

final class ChatFormState extends Equatable {
  const ChatFormState({
    this.chatName = const ChatName.pure(),
    this.uids = const <dynamic>[],
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });
  final ChatName chatName;
  final List<dynamic> uids;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  ChatFormState copyWith({
    ChatName? chatName,
    List<dynamic>? uids,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return ChatFormState(
      chatName: chatName ?? this.chatName,
      uids: uids ?? this.uids,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [chatName, uids, status, isValid, errorMessage];
}
