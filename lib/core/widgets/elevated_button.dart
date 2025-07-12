import 'dart:ui';

import 'package:flutter/material.dart';

const borderRadius = 20.0;

enum ColorType {
  primary,
  secondary,
  tertiary,
  surface;

  Color color(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (this) {
      case ColorType.primary:
        return colorScheme.primary;
      case ColorType.secondary:
        return colorScheme.secondary;
      case ColorType.tertiary:
        return colorScheme.tertiary;
      case ColorType.surface:
        return colorScheme.surfaceContainerLow;
    }
  }

  Color onColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (this) {
      case ColorType.primary:
        return colorScheme.onPrimary;
      case ColorType.secondary:
        return colorScheme.onSecondary;
      case ColorType.tertiary:
        return colorScheme.onTertiary;
      case ColorType.surface:
        return colorScheme.onSurface;
    }
  }
}

ButtonStyle customElevatedButtonStyle(BuildContext context,
    {ColorType colorType = ColorType.primary, bool transparent = false}) {
  final colorScheme = Theme.of(context).colorScheme;
  return ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius)),
    disabledBackgroundColor: colorScheme.surfaceContainerLow,
    disabledForegroundColor: _colorWithAlpha(
      colorType.color(context),
      transparent,
    ),
    backgroundColor: _colorWithAlpha(
      colorType.color(context),
      transparent,
    ),
    foregroundColor: _colorWithAlpha(
      colorType.onColor(context),
      transparent,
    ),
  );
}

Color _colorWithAlpha(Color color, bool transparent) =>
    transparent ? color.withAlpha(150) : color;

class BlurredElevatedButton extends StatelessWidget {
  const BlurredElevatedButton({
    super.key,
    required this.colorType,
    required this.onPressed,
    required this.child,
  });
  final ColorType colorType;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: ElevatedButton(
          style: customElevatedButtonStyle(
            context,
            colorType: colorType,
            transparent: true,
          ),
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
