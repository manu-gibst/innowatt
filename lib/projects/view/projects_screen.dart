import 'dart:math';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:gap/gap.dart';
import 'package:innowatt/core/widgets/elevated_button.dart';
import 'package:innowatt/core/widgets/information_card.dart';
import 'package:innowatt/core/widgets/glowing_backlight.dart';
import 'package:innowatt/core/widgets/light_bulb.dart';
import 'package:innowatt/core/widgets/rounded_triangle_painter.dart';
import 'package:innowatt/projects/bloc/project_bloc.dart';
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

class _ProjectsScreenWrapper extends StatefulWidget {
  const _ProjectsScreenWrapper();

  @override
  State<_ProjectsScreenWrapper> createState() => _ProjectsScreenWrapperState();
}

class _ProjectsScreenWrapperState extends State<_ProjectsScreenWrapper> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
  }

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
          CustomScrollView(
            physics: PageScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: ProjectsCollection()),
              SliverAppBar(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                centerTitle: true,
                title: Text(_activeIndex.toString()),
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
            ],
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
    final colorScheme = Theme.of(context).colorScheme;

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
                          if (state.projects == null ||
                              state.projects!.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InformationCard(
                                  type: StatusType.neutral,
                                  title:
                                      "Looks like you don't have any projects yet",
                                  bottomButton: InformationButton(
                                    text: "Create new project",
                                    icon: null,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            );
                          }
                          return CustomCarousel(
                            itemCountAfter: 1,
                            itemCountBefore: 1,
                            alignment: Alignment.center,
                            depthOrder: DepthOrder.selectedInFront,
                            scrollDirection: Axis.horizontal,
                            scrollSpeed: 0.4,
                            physics: PageScrollPhysics(),
                            onSelectedItemChanged: (i) {
                              context.read<ProjectBloc>().add(
                                ProjectSelected(project: state.projects![i]),
                              );
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
                                  opacity: pow(scale, 3).toDouble(),
                                  child: child,
                                ),
                              );
                            },
                            children: [
                              ProjectContainer(
                                projectName: "Project Name",
                                completion: 0.8,
                                active: true,
                              ),
                              ProjectContainer(
                                projectName: "Another Name",
                                completion: 0.5,
                                active: true,
                              ),
                              ProjectContainer(
                                projectName: "Third Name",
                                completion: 0.0,
                                active: true,
                              ),
                            ],
                          );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProjectContainer extends StatelessWidget {
  const ProjectContainer({
    super.key,
    required this.projectName,
    required this.completion,
    required this.active,
  });

  final String projectName;
  final double completion;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final width = min(
      MediaQuery.of(context).size.height / 2,
      MediaQuery.of(context).size.width,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: padding),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width / 2 - padding),
          gradient: LinearGradient(
            colors: [
              active ? colorScheme.primaryFixed : colorScheme.surfaceBright,
              active ? colorScheme.primary : colorScheme.surface,
            ],
            stops: [0.3, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: BlackSpotWithLamp(brightness: active ? completion : 0.0),
            ),
            if (active)
              Align(
                alignment: Alignment(0, 1 / 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding / 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        projectName,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: textTheme.displaySmall!.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        'completion: ${(completion * 100).round()}%',
                        style: textTheme.bodyLarge!.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (active)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: (width - padding * 2) / 2 - 90 / 2 - 20,
                  ),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      // color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(90 / 2),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(1, 3),
                          blurRadius: 1,
                          color: colorScheme.secondary,
                          spreadRadius: 1,
                        ),
                        BoxShadow(color: colorScheme.surface),
                        BoxShadow(
                          offset: Offset(0, 6),
                          blurRadius: 4,
                          color: colorScheme.primary,
                          spreadRadius: -4,
                        ),
                        BoxShadow(
                          offset: Offset(0, 6),
                          blurRadius: 4,
                          color: colorScheme.surfaceContainer.withAlpha(90),
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      painter: RoundedTrianglePainter(
                        radius: 9,
                        size: 30,
                        color: colorScheme.secondary,
                        filled: true,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BlackSpotWithLamp extends StatelessWidget {
  const BlackSpotWithLamp({super.key, required this.brightness});

  final double brightness;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final width = min(
      MediaQuery.of(context).size.height / 2,
      MediaQuery.of(context).size.width,
    );

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Black Spot
          Container(
            width: width - padding * 4,
            height: width - padding * 4,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular((width - padding * 4) / 2),
            ),
          ),
          LightBulb(size: (width - padding * 4) / 2, brightness: brightness),
        ],
      ),
    );
  }
}
