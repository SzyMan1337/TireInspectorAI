import 'package:flutter/material.dart';

class HighlightButton extends StatelessWidget {
  const HighlightButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String text;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: style ??
          ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48.0),
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.primary,
            foregroundColor:
                foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
          ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
