import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innowatt/projects/bloc/project_bloc.dart';
import 'package:innowatt/projects/slider/cubit/slider_cubit.dart';

const size = 10.0;

class PageSlider extends StatelessWidget {
  const PageSlider({
    super.key,
    required this.count,
    required this.selectedIndex,
  });

  final int count;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SliderCubit(
          size: context.read<ProjectBloc>().state.projects!.length + 1),
      child: _PageSliderWrapper(),
    );
  }
}

class _PageSliderWrapper extends StatelessWidget {
  const _PageSliderWrapper();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocListener<ProjectBloc, ProjectState>(
      listenWhen: (previous, current) =>
          previous.selectedIndex != current.selectedIndex ||
          previous.projects?.length != current.projects?.length,
      listener: (context, state) {
        // Listening to changes from ProjectBloc
        // and invoking selected() function in SliderCubit
        final sliderCubit = context.read<SliderCubit>();

        sliderCubit.onSelected(state.selectedIndex ?? state.projects!.length);
        sliderCubit.onSizeChanged((state.projects?.length ?? 0) + 1);
      },
      child: SizedBox(
        height: 80,
        child: Stack(
          alignment: Alignment(0, -1 / 3),
          children: [
            BlocBuilder<SliderCubit, SliderState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(size / 2),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(size),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: size,
                    children: List.generate(
                      state.range,
                      (index) {
                        final trueIndex = state.left + index;
                        return _Dot(
                          active: state.selectedIndex == trueIndex,
                          minimized: state.shouldMinimize(trueIndex),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension on SliderState {
  bool shouldMinimize(int index) {
    // Minimize if it is the right bound and it did not reach the end.
    // Similar logic for the left bound.
    if (right == index && !rightReachedEnd()) return true;
    if (left == index && !leftReachedStart()) return true;
    return false;
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.active,
    required this.minimized,
  });

  final bool active;
  final bool minimized;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: minimized ? size / 2 : size,
      height: minimized ? size / 2 : size,
      decoration: BoxDecoration(
        color: active ? colorScheme.secondary : colorScheme.surface,
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}
