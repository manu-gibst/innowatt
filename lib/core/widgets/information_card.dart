import 'package:flutter/material.dart';

const borderRadius = 20.0;

enum StatusType {
  error,
  loading,
  success,
  neutral;

  Color _backgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (this) {
      case StatusType.error:
        return colorScheme.errorContainer;
      case StatusType.loading:
      case StatusType.neutral:
        return colorScheme.surfaceContainerHigh;
      case StatusType.success:
        return colorScheme.primaryContainer;
    }
  }

  Color _foregroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (this) {
      case StatusType.error:
        return colorScheme.onErrorContainer;
      case StatusType.loading:
      case StatusType.neutral:
        return colorScheme.onSurface;
      case StatusType.success:
        return colorScheme.onPrimaryContainer;
    }
  }

  Widget? _iconOrWidget(BuildContext context) {
    switch (this) {
      case StatusType.error:
        return Icon(Icons.error, color: _foregroundColor(context));
      case StatusType.loading:
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(color: _foregroundColor(context)),
        );
      case StatusType.success:
        return Icon(Icons.done, color: _foregroundColor(context));
      case StatusType.neutral:
        return null;
    }
  }

  String? _title() {
    switch (this) {
      case StatusType.error:
        return 'An unknown error has occured';
      case StatusType.loading:
        return 'The content is loading...';
      case StatusType.success:
        return 'Success!';
      case StatusType.neutral:
        return null;
    }
  }

  String? _subtitle() {
    switch (this) {
      case StatusType.error:
        return 'Please try again later';
      case StatusType.loading:
        return null;
      case StatusType.success:
      case StatusType.neutral:
        return null;
    }
  }
}

class InformationCard extends StatelessWidget {
  const InformationCard({
    super.key,
    this.title,
    this.subtitle,
    required this.type,
    this.bottomButton,
  });

  final String? title;
  final String? subtitle;
  final StatusType type;
  final InformationButton? bottomButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 0,
        children: [
          Card(
            color: type._backgroundColor(context),
            shape: _getShape(),
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      title ?? type._title() ?? "",
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: type._foregroundColor(context),
                      ),
                    ),
                  ),
                  if (type._iconOrWidget(context) != null)
                    type._iconOrWidget(context)!,
                ],
              ),
            ),
          ),
          if (bottomButton != null) bottomButton!.build(context),
          if (subtitle != null || type._subtitle() != null)
            Text(subtitle ?? type._subtitle()!),
        ],
      ),
    );
  }

  ShapeBorder? _getShape() {
    return RoundedRectangleBorder(
      borderRadius: bottomButton != null
          ? BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            )
          : BorderRadius.circular(borderRadius),
    );
  }
}

class InformationButton {
  const InformationButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });
  final String text;
  final Icon? icon;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          foregroundColor: Theme.of(context).colorScheme.primary,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius),
            ),
          ),
        ),
        child: icon == null ? Text(text) : Row(children: [Text(text), icon!]),
      ),
    );
  }
}
