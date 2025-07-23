import 'dart:math';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:gap/gap.dart';
import 'package:innowatt/core/widgets/information_card.dart';
import 'package:innowatt/core/widgets/glowing_backlight.dart';
import 'package:innowatt/lessons/view/lessons_sliver_list.dart';
import 'package:innowatt/projects/bloc/project_bloc.dart';
import 'package:innowatt/projects/single_project/single_project_sliver.dart';
import 'package:innowatt/projects/view/blank_project_container.dart';
import 'package:innowatt/projects/view/project_container.dart';
import 'package:innowatt/projects/slider/page_slider.dart';
import 'package:projects_repository/projects_repository.dart';

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
                    SliverToBoxAdapter(child: ProjectsCollection()),
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

class ProjectsCollection extends StatefulWidget {
  const ProjectsCollection({super.key});

  @override
  State<ProjectsCollection> createState() => _ProjectsCollectionState();
}

class _ProjectsCollectionState extends State<ProjectsCollection> {
  late final CustomCarouselScrollController controller;

  @override
  void initState() {
    controller = CustomCarouselScrollController(initialItem: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final width = min(
      MediaQuery.of(context).size.height / 2,
      MediaQuery.of(context).size.width,
    );

    return Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.antiAlias,
      children: [
        Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: width,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Text(
                  "CHARGE YOUR IDEA",
                  style: textTheme.titleMedium!.copyWith(letterSpacing: 7),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: BlocConsumer<ProjectBloc, ProjectState>(
                    listenWhen: (previous, current) =>
                        previous.projects?.length != current.projects?.length,
                    listener: (context, state) async {
                      // Making sure that when new projects are added,
                      // the controller stays on the selected project.
                      await controller.animateToItem(
                          state.selectedIndex ?? state.projects!.length);
                    },
                    builder: (context, state) {
                      final projectBloc = context.read<ProjectBloc>();
                      switch (state.status) {
                        case ProjectStatus.initial:
                        case ProjectStatus.waiting:
                          return InformationCard(
                            type: StatusType.loading,
                            title: "Loading Projects...",
                          );
                        case ProjectStatus.failure:
                          return InformationCard(type: StatusType.error);
                        case ProjectStatus.success:
                          return CustomCarousel(
                            itemCountAfter: state.projects!.length > 1 ? 1 : 0,
                            itemCountBefore: state.projects!.length > 2 ? 1 : 0,
                            alignment: Alignment.center,
                            depthOrder: DepthOrder.selectedInFront,
                            scrollDirection: Axis.horizontal,
                            scrollSpeed: 0.4,
                            // loop: true,
                            physics: PageScrollPhysics(),
                            onSelectedItemChanged: (i) {
                              // There is an exception of blank project container.
                              // If the selected project is blank - it is the last one.
                              final selectedIndex =
                                  i == state.projects!.length ? null : i;
                              projectBloc
                                  .add(ProjectSelected(index: selectedIndex));
                            },
                            controller: controller,
                            effectsBuilder: (_, ratio, child) {
                              double o = (ratio * -1 + 0.5) * pi;
                              double r = width * 0.4, x = r * cos(o);
                              double scale = (sin(o) + 2) / 3;
                              // double blur = 16 * (1 - scale);

                              return Transform(
                                transform: Matrix4.identity()
                                  ..translate(x)
                                  ..scale(scale),
                                alignment: Alignment.center,
                                child: Opacity(
                                  opacity: scale,
                                  child: child,
                                ),
                              );
                            },
                            children: [
                              ...state.projects!.map<Widget>((project) {
                                return ProjectContainer(
                                  key: Key(
                                      '__projectContainer_${project.id!}__'),
                                  projectName: project.name,
                                  completion: project.completion,
                                  active: project == state.selectedProject,
                                );
                              }),
                              BlankProjectContainer(
                                key: Key('__blankProjectContainer__'),
                              ),
                            ],
                          );
                      }
                    },
                  ),
                ),
                BlocBuilder<ProjectBloc, ProjectState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case ProjectStatus.initial:
                      case ProjectStatus.waiting:
                      case ProjectStatus.failure:
                        return MaxGap(80);
                      case ProjectStatus.success:
                        return PageSlider(
                          count: state.projects!.length + 1,
                          selectedIndex:
                              state.selectedIndex ?? state.projects!.length,
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
