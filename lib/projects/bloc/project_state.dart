part of 'project_bloc.dart';

final class ProjectState extends Equatable {
  const ProjectState({
    required this.index,
    required this.projects,
  });
  final int index;
  final List<Project>? projects;

  ProjectState copyWith({
    int? index,
    List<Project>? projects,
  }) {
    return ProjectState(
      index: index ?? this.index,
      projects: projects ?? this.projects,
    );
  }

  @override
  List<Object?> get props => [index, projects];
}
