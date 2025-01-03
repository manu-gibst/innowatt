import 'package:flutter/material.dart';

ButtonStyle customElevatedButtonStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
    disabledForegroundColor: Theme.of(context).colorScheme.primary,
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
  );
}
