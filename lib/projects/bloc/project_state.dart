part of 'project_bloc.dart';

enum ProjectStatus { initial, waiting, success, failure }

final class ProjectState extends Equatable {
  const ProjectState({
    required this.selectedIndex,
    required this.projects,
    required this.status,
  });

  /// Selected index. \
  /// Important notice! If the selected index == null, it means that the
  /// screen should be focused on the BlankProjectContainer, which is the
  /// last element.
  final int? selectedIndex;
  final List<Project>? projects;
  final ProjectStatus status;

  Project? get selectedProject {
    if (selectedIndex == null || projects == null) return null;
    return projects![selectedIndex!];
  }

  ProjectState copyWith({
    Object? selectedIndex = _unset,
    List<Project>? projects,
    ProjectStatus? status,
  }) {
    return ProjectState(
      selectedIndex:
          selectedIndex == _unset ? this.selectedIndex : selectedIndex as int?,
      projects: projects ?? this.projects,
      status: status ?? this.status,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
        selectedIndex,
        projects,
        status,
      ];

  @override
  String toString() =>
      'ProjectState (selectedIndex: $selectedIndex, projects.count = ${projects?.length}, status: ${status.name})';
}
