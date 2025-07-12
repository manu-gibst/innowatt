import 'package:formz/formz.dart';

/// Validation errors for the [ChatName] [FormzInput]
enum GenericNameValidationError {
  /// Empty error
  empty,
  invalidSymbols;

  String text() {
    if (this == GenericNameValidationError.empty)
      return 'Field cannot be empty';
    if (this == GenericNameValidationError.invalidSymbols)
      return 'Field contains invalid symbols';
    return '';
  }
}

/// {@template chat_name}
/// Form input for an generic name input
/// {@endtemplate}
class GenericName extends FormzInput<String, GenericNameValidationError> {
  /// {@macro chat_name}
  const GenericName.pure() : super.pure('');

  /// {@macro chat_name}
  const GenericName.dirty([String value = '']) : super.dirty(value);

  @override
  GenericNameValidationError? validator(String value) {
    if (value.isEmpty) return GenericNameValidationError.empty;
    final valid = RegExp(
        r'^[a-zA-Z0-9 _-]+$'); // Only allow letters, numbers, space, _ and -
    if (!valid.hasMatch(value))
      return GenericNameValidationError.invalidSymbols;
    return null;
  }
}
