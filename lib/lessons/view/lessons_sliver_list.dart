import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innowatt/core/widgets/information_card.dart';
import 'package:innowatt/lessons/bloc/lessons_bloc.dart';
import 'package:innowatt/lessons/view/lesson_module_container.dart';
import 'package:innowatt/projects/bloc/project_bloc.dart';
import 'package:lessons_repository/lessons_repository.dart';

class LessonsSliverList extends StatelessWidget {
  const LessonsSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationRepository>().currentUser.id;
    return BlocProvider(
      lazy: false,
      create: (context) => LessonsBloc(
        lessonsRepository: LessonsRepository(uid: uid),
      )..add(LessonsFetched()),
      child: _LessonsSliverList(),
    );
  }
}

class _LessonsSliverList extends StatelessWidget {
  const _LessonsSliverList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonsBloc, LessonsState>(
      builder: (context, state) {
        if (state.status != LessonsStatus.success) {
          return SliverToBoxAdapter(
            child: Container(
              constraints: BoxConstraints(
                minHeight: _getHeight(context),
              ),
              child: switch (state.status) {
                LessonsStatus.failure => InformationCard(
                    type: StatusType.error, title: "Error loading lessons..."),
                _ => InformationCard(
                    type: StatusType.loading, title: "Loading lessons..."),
              },
            ),
          );
        }
        return SliverList.builder(
          itemCount: state.lessons.length + 1,
          itemBuilder: (context, index) {
            if (index == state.lessons.length) {
              // Adding extra space to fill remaining
              final height = MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  state.lessons.length * 100;
              return Container(
                height: height < 0 ? 0 : height,
              );
            }
            final lesson = state.lessons[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: LessonModuleContainer.fromProject(
                lesson: lesson,
                project: context.read<ProjectBloc>().state.selectedProject!,
              ),
            );
          },
        );
      },
    );
  }
}

double _getHeight(BuildContext context) =>
    MediaQuery.of(context).size.height -
    kToolbarHeight -
    MediaQuery.of(context).padding.vertical;
