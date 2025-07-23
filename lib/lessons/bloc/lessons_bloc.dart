import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lessons_repository/lessons_repository.dart';

part 'lessons_event.dart';
part 'lessons_state.dart';

class LessonsBloc extends Bloc<LessonsEvent, LessonsState> {
  LessonsBloc({required LessonsRepository lessonsRepository})
      : _lessonsRepository = lessonsRepository,
        super(LessonsState()) {
    on<LessonsFetched>(_onFetched);
    on<LessonsNextPageFetched>(_onNextPageFetched);
  }

  final LessonsRepository _lessonsRepository;

  Future<void> _onFetched(
    LessonsFetched event,
    Emitter<LessonsState> emit,
  ) async {
    emit(state.copyWith(status: LessonsStatus.loading));
    try {
      await emit.forEach(
        _lessonsRepository.lessonsStream(),
        onData: (lessons) {
          // Sorting the lessons by its id's
          lessons.sort((a, b) => a.id.compareTo(b.id));
          return state.copyWith(
            status: LessonsStatus.success,
            lessons: lessons,
          );
        },
      );
    } catch (_) {
      emit(state.copyWith(status: LessonsStatus.failure));
    }
  }

  Future<void> _onNextPageFetched(
    LessonsNextPageFetched event,
    Emitter<LessonsState> emit,
  ) async {
    emit(state.copyWith(status: LessonsStatus.loading));
    try {
      await _lessonsRepository.requestNextPage();
      emit(state.copyWith(status: LessonsStatus.success));
    } catch (_) {
      emit(state.copyWith(status: LessonsStatus.failure));
    }
  }

  @override
  Future<void> close() async {
    await _lessonsRepository.dispose();
    return super.close();
  }
}
