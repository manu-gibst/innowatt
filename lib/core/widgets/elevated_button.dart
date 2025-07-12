import 'package:flutter/material.dart';

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
    {ColorType colorType = ColorType.primary}) {
  final colorScheme = Theme.of(context).colorScheme;
  return ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    disabledBackgroundColor: colorScheme.surfaceContainerLow,
    disabledForegroundColor: colorType.color(context),
    backgroundColor: colorType.color(context),
    foregroundColor: colorType.onColor(context),
  );
}
