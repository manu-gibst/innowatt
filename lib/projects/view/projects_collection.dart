import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:gap/gap.dart';
import 'package:innowatt/core/widgets/information_card.dart';
import 'package:innowatt/projects/bloc/project_bloc.dart';
import 'package:innowatt/projects/slider/page_slider.dart';
import 'package:innowatt/projects/view/blank_project_container.dart';
import 'package:innowatt/projects/view/project_container.dart';

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
