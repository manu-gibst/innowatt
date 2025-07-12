part of 'project_bloc.dart';

enum ProjectStatus { initial, waiting, success, failure }

final class ProjectState extends Equatable {
  const ProjectState({
    required this.selectedProject,
    required this.projects,
    required this.status,
  });
  final Project? selectedProject;
  final List<Project>? projects;
  final ProjectStatus status;

  ProjectState copyWith({
    Project? selectedProject,
    List<Project>? projects,
    ProjectStatus? status,
  }) {
    return ProjectState(
      selectedProject: selectedProject ?? this.selectedProject,
      projects: projects ?? this.projects,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [selectedProject, projects];

  @override
  String toString() =>
      'ProjectState (selectedProject: ${selectedProject?.name}, projects.count = ${projects?.length}, status: ${status.name})';
}
