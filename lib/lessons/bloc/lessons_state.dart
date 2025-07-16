part of 'lessons_bloc.dart';

enum LessonsStatus { initial, loading, success, failure }

final class LessonsState extends Equatable {
  const LessonsState({
    this.lessons = const <Lesson>[],
    this.status = LessonsStatus.initial,
  });

  final List<Lesson> lessons;
  final LessonsStatus status;

  LessonsState copyWith({
    List<Lesson>? lessons,
    LessonsStatus? status,
  }) {
    return LessonsState(
      lessons: lessons ?? this.lessons,
      status: status ?? this.status,
    );
  }

  @override
  String toString() =>
      'LessonsState (Lessons.count: ${lessons.length}, status: ${status.name})';

  @override
  List<Object> get props => [lessons, status];
}
