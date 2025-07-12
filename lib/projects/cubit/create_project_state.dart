part of 'create_project_cubit.dart';

final class CreateProjectState extends Equatable {
  const CreateProjectState({
    this.name = const GenericName.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final GenericName name;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  @override
  List<Object?> get props => [name, status, isValid, errorMessage];

  CreateProjectState copyWith({
    GenericName? name,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return CreateProjectState(
      name: name ?? this.name,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
