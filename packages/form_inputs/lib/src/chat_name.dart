import 'package:formz/formz.dart';

/// Validation errors for the [ChatName] [FormzInput]
enum ChatNameValidationError {
  /// Empty error
  empty;

  String text() {
    if (this == ChatNameValidationError.empty)
      return 'Please enter name of chat';
    return '';
  }
}

/// {@template chat_name}
/// Form input for an chat name input
/// {@endtemplate}
class ChatName extends FormzInput<String, ChatNameValidationError> {
  /// {@macro chat_name}
  const ChatName.pure() : super.pure('');

  /// {@macro chat_name}
  const ChatName.dirty([String value = '']) : super.dirty(value);

  @override
  ChatNameValidationError? validator(String value) {
    return value.isEmpty ? ChatNameValidationError.empty : null;
  }
}
