import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput]
enum PasswordValidatorError {
  /// Generic invalid error
  invalid
}

class Password extends FormzInput<String, PasswordValidatorError> {
  /// {@macro password}
  const Password.pure() : super.pure('');

  /// {@macro password}
  const Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidatorError? validator(String value) {
    return _passwordRegExp.hasMatch(value)
        ? null
        : PasswordValidatorError.invalid;
  }
}
