import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput]
enum PasswordValidatorError {
  /// Generic invalid error
  invalid,
  short;

  String text() {
    switch (this) {
      case PasswordValidatorError.invalid:
        return 'Password should contain letters';
      case PasswordValidatorError.short:
        return 'Password is too short';
    }
  }
}

class Password extends FormzInput<String, PasswordValidatorError> {
  /// {@macro password}
  const Password.pure() : super.pure('');

  /// {@macro password}
  const Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp = RegExp(r'^(?=.*[A-Za-z])[A-Za-z\d]');

  @override
  PasswordValidatorError? validator(String value) {
    if (_passwordRegExp.hasMatch(value)) {
      return value.length >= 6 ? null : PasswordValidatorError.short;
    }
    return PasswordValidatorError.invalid;
  }
}
