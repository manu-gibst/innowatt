import 'package:flutter/material.dart';

class GlowingBacklight extends StatelessWidget {
  const GlowingBacklight({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.primary.withAlpha(50),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(300 / 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 150,
            color: colorScheme.primary,
          ),
          BoxShadow(
            blurRadius: 250,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
