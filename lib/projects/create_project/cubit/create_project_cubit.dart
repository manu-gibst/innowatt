import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:innowatt/repository/chat_repository/src/exceptions/exception.dart'
    show FirestoreDatabaseFailure;
import 'package:projects_repository/projects_repository.dart';

part 'create_project_state.dart';

class CreateProjectCubit extends Cubit<CreateProjectState> {
  CreateProjectCubit({required ProjectsRepository projectsRepository})
      : _projectsRepository = projectsRepository,
        super(CreateProjectState());

  final ProjectsRepository _projectsRepository;

  void nameChanged(String value) {
    final name = GenericName.dirty(value);
    emit(state.copyWith(
      name: name,
      isValid: Formz.validate([name]),
    ));
  }

  Future<void> createProject() async {
    if (!_validateAll()) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _projectsRepository.createProject(
        name: state.name.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on FirestoreDatabaseFailure catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        status: FormzSubmissionStatus.failure,
      ));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  bool _validateAll() {
    emit(state.copyWith(
      name: GenericName.dirty(state.name.value),
      isValid: Formz.validate([state.name]),
    ));
    return state.isValid;
  }
}
