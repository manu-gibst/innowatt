import 'package:flutter/material.dart';
import 'package:innowatt/old/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyChatDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'Cannot share empty chat',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
