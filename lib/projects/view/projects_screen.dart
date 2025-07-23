import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innowatt/app/router/custom_navbar/cubit/custom_bottom_navbar_cubit.dart';
import 'package:innowatt/core/widgets/glowing_backlight.dart';
import 'package:innowatt/lessons/view/lessons_sliver_list.dart';
import 'package:innowatt/projects/bloc/project_bloc.dart';
import 'package:innowatt/projects/single_project/single_project_sliver.dart';
import 'package:innowatt/projects/view/projects_collection.dart';
import 'package:projects_repository/projects_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

const padding = 40.0;

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationRepository>().currentUser.id;
    return BlocProvider(
      lazy: false,
      create: (context) => ProjectBloc(
        projectsRepository: ProjectsRepository(uid: uid),
        userId: uid,
      )..add(ProjectsFetched()),
      child: _ProjectsScreenWrapper(),
    );
  }
}

class _ProjectsScreenWrapper extends StatelessWidget {
  const _ProjectsScreenWrapper();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment(3, 1.6),
            child: GlowingBacklight(colorScheme: colorScheme),
          ),
          BlocBuilder<ProjectBloc, ProjectState>(
            buildWhen: (previous, current) =>
                previous.selectedIndex != current.selectedIndex,
            builder: (context, state) {
              return CustomScrollView(
                physics: PageScrollPhysics(),
                slivers: [
                  if (state.selectedIndex == null)
                    SliverToBoxAdapter(child: ProjectsCollection()),
                  if (state.selectedIndex != null) ...[
                    SliverToBoxAdapter(
                      child: VisibilityDetector(
                        key: Key('projects-projectsScreen-visibilityDetector'),
                        onVisibilityChanged: (info) {
                          context
                              .read<CustomBottomNavbarCubit>()
                              .opacityChanged(1 - info.visibleFraction);
                        },
                        child: ProjectsCollection(),
                      ),
                    ),
                    SingleProjectSliverAppBar(
                      key: Key(state.selectedProject!.id!),
                      projectName: state.selectedProject!.name,
                      onRenameProject: (value) {
                        context
                            .read<ProjectBloc>()
                            .add(ProjectRenamed(name: value));
                      },
                    ),
                    LessonsSliverList(),
                  ]
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
