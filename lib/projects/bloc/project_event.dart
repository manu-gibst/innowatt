part of 'project_bloc.dart';

sealed class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

final class ProjectSelected extends ProjectEvent {
  const ProjectSelected({required this.index});
  final int index;
}

final class ProjectsFetched extends ProjectEvent {}
