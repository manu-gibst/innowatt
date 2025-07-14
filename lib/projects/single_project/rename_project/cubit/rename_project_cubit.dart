import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'rename_project_state.dart';

class RenameProjectCubit extends Cubit<RenameProjectState> {
  RenameProjectCubit(
      {required String name, required void Function(String value) onRename})
      : _onRename = onRename,
        _initialName = name,
        super(RenameProjectState(name: GenericName.dirty(name)));

  String _initialName;

  final void Function(String value) _onRename;

  void toggleEditing() {
    emit(state.toggleEditing());
    if (!state.editing) {
      // if editing exited without saving, then return initial name
      emit(state.copyWith(name: GenericName.dirty(_initialName)));
    }
  }

  void nameChanged(String value) {
    final name = GenericName.dirty(value);
    emit(state.copyWith(
      name: name,
      isValid: Formz.validate([name]),
    ));
  }

  Future<void> renameProject() async {
    print("object");
    if (!_validateAll()) return;

    if (state.name.value == _initialName) {
      emit(state.copyWith(editing: false));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    await Future.delayed(const Duration(seconds: 2));

    try {
      // If the name didn't change, then do nothing
      _onRename(state.name.value);

      _initialName = state.name.value;
      emit(state.copyWith(
          status: FormzSubmissionStatus.success, editing: false));
      emit(state.copyWith(status: FormzSubmissionStatus.initial));
    } catch (_) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure, editing: false));
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
