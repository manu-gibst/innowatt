import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innowatt/core/widgets/information_card.dart';
import 'package:innowatt/lessons/bloc/lessons_bloc.dart';
import 'package:lessons_repository/lessons_repository.dart';

class LessonsSliverList extends StatelessWidget {
  const LessonsSliverList({
    super.key,
    required this.controller,
  });

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationRepository>().currentUser.id;
    return BlocProvider(
      lazy: false,
      create: (context) => LessonsBloc(
        lessonsRepository: LessonsRepository(uid: uid),
      )..add(LessonsFetched()),
      child: _LessonsSliverList(controller: controller),
    );
  }
}

class _LessonsSliverList extends StatelessWidget {
  const _LessonsSliverList({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
            final project = state.lessons[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colorScheme.surfaceContainerHigh,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: textTheme.titleMedium!
                                .copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                          Text(
                            project.description,
                            style: textTheme.bodySmall!
                                .copyWith(color: colorScheme.onSurface),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 70,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
            );
          },
        );
        return SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(15),
            height: _getHeight(context),
            child: CustomScrollView(
              slivers: [
                SliverList.builder(
                  itemCount: state.lessons.length * 10,
                  itemBuilder: (context, index) {
                    final project = state.lessons[index % 3];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colorScheme.surfaceContainerHigh,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.name,
                                    style: textTheme.titleMedium!.copyWith(
                                        color: colorScheme.onSurfaceVariant),
                                  ),
                                  Text(
                                    project.description,
                                    style: textTheme.bodySmall!
                                        .copyWith(color: colorScheme.onSurface),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 70,
                              color: colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

double _getHeight(BuildContext context) =>
    MediaQuery.of(context).size.height -
    kToolbarHeight -
    MediaQuery.of(context).padding.vertical;
