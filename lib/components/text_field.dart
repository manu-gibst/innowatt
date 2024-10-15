import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool? obscureText;
  final bool? enableSuggestions;
  final bool? autocorrect;
  final TextInputType? keyboardType;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText,
    this.enableSuggestions,
    this.autocorrect,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
      ),
      controller: controller,
    );
  }
}
