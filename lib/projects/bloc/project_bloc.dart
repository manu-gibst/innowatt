import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:projects_repository/projects_repository.dart'
    show ProjectsRepository, Project;

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc({
    required String userId,
    required ProjectsRepository projectsRepository,
  })  : _projectsRepository = projectsRepository,
        super(ProjectState(
          projects: null,
          selectedIndex: null,
          status: ProjectStatus.initial,
        )) {
    on<ProjectSelected>(_onSelected);
    on<ProjectsFetched>(_onFetched);
    on<ProjectCreated>(_onCreated);
    on<ProjectRenamed>(_onRenamed);
    on<ProjectProgressed>(_onProgressed);
  }

  final ProjectsRepository _projectsRepository;

  Future<void> _onFetched(
    ProjectsFetched event,
    Emitter<ProjectState> emit,
  ) async {
    emit(state.copyWith(status: ProjectStatus.waiting));
    try {
      return emit.forEach(
        _projectsRepository.getProjectsStream(),
        onData: (data) {
          return state.copyWith(
            status: ProjectStatus.success,
            projects: data,
            selectedIndex: state.projects == null ? null : 0,
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(status: ProjectStatus.failure));
    }
  }

  Future<void> _onCreated(
    ProjectCreated event,
    Emitter<ProjectState> emit,
  ) async {
    emit(state.copyWith(status: ProjectStatus.waiting));
    try {
      await _projectsRepository.createProject(name: event.projectName);
      emit(state.copyWith(status: ProjectStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ProjectStatus.failure));
    }
  }

  void _onSelected(
    ProjectSelected event,
    Emitter<ProjectState> emit,
  ) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  Future<void> _onRenamed(
    ProjectRenamed event,
    Emitter<ProjectState> emit,
  ) async {
    emit(state.copyWith(status: ProjectStatus.waiting));
    try {
      final updatedProject = state.selectedProject!.copyWith(name: event.name);
      await _projectsRepository.updateProject(updatedProject: updatedProject);
      emit(state.copyWith(status: ProjectStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ProjectStatus.failure));
    }
  }

  Future<void> _onProgressed(
    ProjectProgressed event,
    Emitter<ProjectState> emit,
  ) async {
    emit(state.copyWith(status: ProjectStatus.waiting));
    try {
      final updatedProject = state.selectedProject!.copyWith(
        currentModule: event.newProgress,
      );
      await _projectsRepository.updateProject(updatedProject: updatedProject);
      emit(state.copyWith(status: ProjectStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ProjectStatus.failure));
    }
  }

  @override
  Future<void> close() async {
    await _projectsRepository.dispose();
    return super.close();
  }
}
