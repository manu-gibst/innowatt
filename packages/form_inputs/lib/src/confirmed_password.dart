import 'package:formz/formz.dart';

/// Validation errors for the [ConfirmedPassword] [FormzInput]
enum ConfirmedPasswordValidationError {
  /// Generic invalid error
  invalid;

  String text() {
    if (this == ConfirmedPasswordValidationError.invalid) {
      return 'Password should contain letters';
    }
    return '';
  }
}

/// {@template confirmed_password}
/// Form input for a confirmed password
/// {@endtemplate}
class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  /// {@macro confirmed_password}
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  /// {@macro confirmed_password}
  const ConfirmedPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  /// The original password.
  final String password;

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    return password == value ? null : ConfirmedPasswordValidationError.invalid;
  }
}
