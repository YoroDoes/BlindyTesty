import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    required fullTitle,
    backArrowAction,
    backgroundColor,
    shadowColor,
    foregroundColor,
  }) : super(
          key: key,
          title: Builder(builder: (context) {
            return Row(
              children: [
                backArrowAction != null
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: backArrowAction,
                      )
                    : const Center(),
                backArrowAction != null
                    ? const Padding(padding: EdgeInsets.all(15.0))
                    : const Center(),
                fullTitle,
              ],
            );
          }),
          backgroundColor: backgroundColor,
          shadowColor: shadowColor,
          foregroundColor: foregroundColor,
        );
}
