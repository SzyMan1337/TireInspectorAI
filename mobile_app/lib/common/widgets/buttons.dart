import 'package:flutter/material.dart';

class HighlightButton extends StatelessWidget {
  const HighlightButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
  });

  final String text;
  final VoidCallback onPressed;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: style ??
          ElevatedButton.styleFrom(
            minimumSize: const Size(
              double.infinity,
              48.0,
            ),
          ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
