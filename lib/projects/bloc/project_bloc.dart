import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:innowatt/projects/models/project.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc({required String userId})
      : super(ProjectState(
          index: 0,
          projects: null,
        )) {
    on<ProjectSelected>(_onSelected);
    on<ProjectsFetched>(_onFetched);
  }

  final int index = 0;

  void _onFetched(
    ProjectsFetched event,
    Emitter<ProjectState> emit,
  ) {
    // TODO: Fetch projects from repo
  }

  void _onSelected(
    ProjectSelected event,
    Emitter<ProjectState> emit,
  ) {
    emit(state.copyWith(index: event.index));
  }
}
