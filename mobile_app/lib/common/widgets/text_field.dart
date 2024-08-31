import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.fieldController,
    required this.fieldValidator,
    required this.label,
    this.obscureText = false,
    this.maxLines = 1,
    this.decoration,
  });

  final TextEditingController fieldController;
  final String? Function(String?) fieldValidator;
  final String label;
  final bool obscureText;
  final int maxLines;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: fieldController,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: maxLines,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
      validator: fieldValidator,
    );
  }
}
