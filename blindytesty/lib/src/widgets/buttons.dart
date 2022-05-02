import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  const SelectionButton(
      {Key? key,
      this.background,
      this.foreground,
      this.fontSize,
      this.onPressed,
      this.child})
      : super(key: key);

  final dynamic onPressed;
  final dynamic child;
  final Color? background;
  final Color? foreground;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: child,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(30.0),
        textStyle: TextStyle(
          fontSize: fontSize ?? 40.0,
          fontWeight: FontWeight.bold,
        ),
        shadowColor: background,
        primary: background,
        onPrimary: foreground,
      ),
    );
  }
}
