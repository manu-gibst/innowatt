part of 'rename_project_cubit.dart';

final class RenameProjectState extends Equatable {
  const RenameProjectState({
    required this.name,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.editing = false,
    this.errorMessage,
  });

  final GenericName name;
  final FormzSubmissionStatus status;
  final bool isValid;
  final bool editing;
  final String? errorMessage;

  @override
  List<Object?> get props => [name, status, isValid, editing, errorMessage];

  @override
  toString() =>
      'RenameProjectState(name: ${name.value}, status: ${status.name})';

  RenameProjectState toggleEditing() => copyWith(editing: !editing);

  RenameProjectState copyWith({
    GenericName? name,
    FormzSubmissionStatus? status,
    bool? isValid,
    bool? editing,
    String? errorMessage,
  }) {
    return RenameProjectState(
      name: name ?? this.name,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      editing: editing ?? this.editing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
