import 'dart:math';
import 'package:flutter/material.dart';
import 'package:innowatt/core/widgets/light_bulb.dart';
import 'package:innowatt/core/widgets/rounded_triangle_painter.dart';
import 'package:innowatt/projects/view/projects_screen.dart';

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
    return ElevatedButton(
        onPressed: () {
          print("object");
        },
        child: Text("data"));
    print("ProjectContainer");
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
              child: _BlackSpotWithLamp(brightness: active ? completion : 0.0),
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

class _BlackSpotWithLamp extends StatelessWidget {
  const _BlackSpotWithLamp({required this.brightness});

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
