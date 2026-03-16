import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class UiTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  const UiTitle({
    Key? key,
    required this.text,
    this.fontSize = 24.0,
    this.color = AppColors.textPrimary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
