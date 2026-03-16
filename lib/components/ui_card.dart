import 'package:flutter/material.dart';

class UiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final double borderRadius;
  final Color backgroundColor;

  const UiCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.elevation = 4.0,
    this.borderRadius = 12.0,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: backgroundColor,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
