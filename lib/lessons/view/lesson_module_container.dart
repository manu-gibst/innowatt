import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:innowatt/app/router/custom_navbar/cubit/custom_bottom_navbar_cubit.dart';
import 'package:innowatt/app/router/routes.dart';
import 'package:innowatt/chat/single_user_chat/view/single_user_chat_screen.dart';
import 'package:lessons_repository/lessons_repository.dart';
import 'package:progress_border/progress_border.dart';
import 'package:projects_repository/projects_repository.dart' show Project;

enum LessonStatus {
  finished,
  inProgress,
  unavailable;

  Color backgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (this) {
      LessonStatus.finished => colorScheme.surfaceContainerHigh,
      LessonStatus.inProgress => colorScheme.primaryContainer,
      LessonStatus.unavailable => colorScheme.surfaceContainer,
    };
  }

  double getOpacity(BuildContext context) {
    if (this == LessonStatus.unavailable) return 0.5;
    return 1;
  }

  Widget getIcon(BuildContext context, {required double progress}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return switch (this) {
      LessonStatus.finished => Icon(
          Icons.check_circle_outline_rounded,
          size: 70,
          color: colorScheme.primary,
        ),
      LessonStatus.inProgress => Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: ProgressBorder.all(
              color: colorScheme.secondary,
              width: 7,
              progress: progress,
            ),
          ),
          child: Center(
            child: Text(
              progress.toPercent(),
              style: textTheme.bodyLarge!.copyWith(
                color: colorScheme.secondary,
              ),
            ),
          ),
        ),
      LessonStatus.unavailable => Padding(
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            Icons.key_off_outlined,
            size: 40,
            color: colorScheme.onSurface,
          ),
        ),
    };
  }
}

class LessonModuleContainer extends StatelessWidget {
  const LessonModuleContainer({
    super.key,
    required this.lesson,
    required this.status,
    required this.progress,
    required this.project,
  });

  final Lesson lesson;
  final LessonStatus status;
  final double progress;
  final Project project;

  factory LessonModuleContainer.fromProject({
    Key? key,
    required Lesson lesson,
    required Project project,
  }) {
    LessonStatus status = LessonStatus.inProgress;
    if (project.currentModule < lesson.id) status = LessonStatus.unavailable;
    if (project.currentModule > lesson.id) status = LessonStatus.finished;

    return LessonModuleContainer(
      lesson: lesson,
      status: status,
      progress: project.completion,
      project: project,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Opacity(
      opacity: status.getOpacity(context),
      child: GestureDetector(
        onTap: status != LessonStatus.unavailable
            ? () async => await _goToChat(context)
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: status.backgroundColor(context),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.name,
                      style: textTheme.titleMedium!
                          .copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    Text(
                      lesson.description,
                      style: textTheme.bodySmall!
                          .copyWith(color: colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
              status.getIcon(context, progress: progress),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToChat(BuildContext context) async {
    final uid = context.read<AuthenticationRepository>().currentUser.id;

    await context.push(Routes.chatRoutes.createOrFetchChat(
      chatId: '$uid;${project.id};${lesson.id}',
      chatName: lesson.name,
    ));
  }
}

extension on double {
  String toPercent() => " ${(this * 100).round()}%";
}
