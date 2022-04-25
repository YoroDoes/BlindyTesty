import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  const SelectionButton(
      {Key? key, this.background, this.foreground, this.onPressed, this.child})
      : super(key: key);

  final dynamic onPressed;
  final dynamic child;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: child,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(30.0),
        textStyle: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        shadowColor: background,
        primary: background,
        onPrimary: foreground,
      ),
    );
  }
}
