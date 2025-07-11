part of 'project_bloc.dart';

sealed class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

final class ProjectSelected extends ProjectEvent {
  const ProjectSelected({required this.project});
  final Project project;
}

final class ProjectsFetched extends ProjectEvent {}

final class ProjectCreated extends ProjectEvent {
  const ProjectCreated({required this.projectName});
  final String projectName;
}

final class ProjectRenamed extends ProjectEvent {
  const ProjectRenamed({required this.name});
  final String name;
}

final class ProjectProgressed extends ProjectEvent {
  const ProjectProgressed({required this.newProgress});
  final int newProgress;
}
