import 'package:flutter/material.dart';

const size = 10.0;

class ProjectSliderIndicator extends StatelessWidget {
  const ProjectSliderIndicator({
    super.key,
    required this.count,
    required this.selectedIndex,
  });

  final int count;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment(0, -1 / 3),
        children: [
          Container(
            padding: const EdgeInsets.all(size / 2),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(size),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: size,
              children: List.generate(
                count,
                (index) => _Dot(active: selectedIndex == index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.active,
  });

  final bool active;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: active ? colorScheme.secondary : colorScheme.surface,
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}
