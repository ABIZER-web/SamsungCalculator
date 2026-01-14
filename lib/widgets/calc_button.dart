import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;
  final double fontSize;
  final FontWeight fontWeight;

  const CalcButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    this.fontSize = 32,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0), // Spacing between buttons
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50), // Perfect Circle
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}