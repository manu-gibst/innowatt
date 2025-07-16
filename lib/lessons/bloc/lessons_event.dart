part of 'lessons_bloc.dart';

sealed class LessonsEvent extends Equatable {
  const LessonsEvent();

  @override
  List<Object> get props => [];
}

final class LessonsFetched extends LessonsEvent {}

final class LessonsNextPageFetched extends LessonsEvent {}
