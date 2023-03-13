import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  late Color containerColor;
  late Color borderColor;
  late double borderWidth;
  late double borderRadius;
  late Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: child,
    );
  }
}
