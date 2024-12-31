import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    super.key,
    this.errorMessage = 'An unknown error has occured. Please try again later.',
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        color: theme.colorScheme.error,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            errorMessage,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
