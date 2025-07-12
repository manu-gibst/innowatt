import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:innowatt/core/widgets/elevated_button.dart';
import 'package:innowatt/projects/create_project/create_project_widget.dart';
import 'package:innowatt/projects/view/projects_screen.dart';

class BlankProjectContainer extends StatelessWidget {
  const BlankProjectContainer({super.key});
  @override
  Widget build(BuildContext context) {
    print("BlankProjectContainer");
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final width = min(
      MediaQuery.of(context).size.height / 2,
      MediaQuery.of(context).size.width,
    );
    return ElevatedButton(
      style: customElevatedButtonStyle(
        context,
        colorType: ColorType.secondary,
      ),
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CreateProjectDialog();
          },
        );
      },
      child: const Text("CREATE"),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: padding),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: Radius.circular(width / 2 - padding),
          dashPattern: [10, 5],
          strokeWidth: 1,
          color: colorScheme.surfaceContainerHighest,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width / 2 - padding),
            color: colorScheme.surfaceContainer.withAlpha(180),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: _BlackSpot(brightness: 0.0),
              ),
              Align(
                alignment: Alignment(0, 1 / 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding / 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gap(50),
                      Text(
                        "Create New Project",
                        textAlign: TextAlign.center,
                        style: textTheme.displaySmall!.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: padding,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: customElevatedButtonStyle(
                              context,
                              colorType: ColorType.secondary,
                            ),
                            onPressed: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return CreateProjectDialog();
                                },
                              );
                            },
                            child: const Text("CREATE"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: (width - padding * 2) / 2 - 90 / 2 - 20,
                  ),
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: const Radius.circular(90),
                      dashPattern: [10, 5],
                      strokeWidth: 1,
                      color: colorScheme.surfaceContainerHighest,
                    ),
                    child: SizedBox(width: 90, height: 90),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlackSpot extends StatelessWidget {
  const _BlackSpot({required this.brightness});

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
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(width - padding * 4),
              dashPattern: [10, 5],
              strokeWidth: 1,
              color: colorScheme.surfaceContainerHighest,
            ),
            child: Container(
              width: width - padding * 4,
              height: width - padding * 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((width - padding * 4) / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
