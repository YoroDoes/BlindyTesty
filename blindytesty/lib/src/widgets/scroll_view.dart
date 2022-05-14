import 'package:flutter/material.dart';

class BouncyScrollView extends ListView {
  BouncyScrollView({
    Key? key,
    required Widget child,
    double padding = 30,
    Axis scrollDirection = Axis.vertical,
  }) : super(
          key: key,
          physics: const BouncingScrollPhysics(),
          scrollDirection: scrollDirection,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: padding)),
            child,
            Padding(padding: EdgeInsets.symmetric(vertical: padding)),
          ],
        );
}
