import 'dart:math';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:gap/gap.dart';
import 'package:innowatt/core/widgets/information_card.dart';
import 'package:innowatt/core/widgets/glowing_backlight.dart';
import 'package:innowatt/projects/bloc/project_bloc.dart';
import 'package:innowatt/projects/create_project/create_project_widget.dart';
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
      body: Stack(
        children: [
          Align(
            alignment: Alignment(3, 1.6),
            child: GlowingBacklight(colorScheme: colorScheme),
          ),
          BlocBuilder<ProjectBloc, ProjectState>(
            builder: (context, state) {
              return CustomScrollView(
                physics: PageScrollPhysics(),
                slivers: [
                  // TODO: FUCK THIS
                  // Just make it so when you need to create a project
                  // it will scroll down and create it there.
                  // neofunctionality, multipurpose and shit.
                  // go diva

                  // If you forgot
                  // --------------------------------------
                  // if (state.selectedIndex == null)
                  //   SliverToBoxAdapter(
                  //     child: ProjectsCollection(),
                  //   ),
                  // --------------------------------------
                  // For some reason Flutter refuses interactivity
                  // if slivers has a single sliver like above.
                  // Your task is to make sure that there are
                  // always more than 1 slivers.
                  // Good luck honey!
                  if (true) ...[
                    SliverToBoxAdapter(child: ProjectsCollection()),
                    SliverAppBar(
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      centerTitle: true,
                      title: Text("0"),
                      pinned: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => const Text("data"),
                        childCount: 50,
                      ),
                    ),
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

class ProjectsCollection extends StatelessWidget {
  const ProjectsCollection({super.key});

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
                  child: BlocBuilder<ProjectBloc, ProjectState>(
                    builder: (context, state) {
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
                          // if (state.projects == null ||
                          //     state.projects!.isEmpty) {
                          //   return CreateProjectWidget();
                          // }
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
                              context
                                  .read<ProjectBloc>()
                                  .add(ProjectSelected(index: selectedIndex));
                            },
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
                                  projectName: project.name,
                                  completion: project.currentModule /
                                      project.modulesCount,
                                  active: project == state.selectedProject,
                                );
                              }),
                              BlankProjectContainer(),
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
