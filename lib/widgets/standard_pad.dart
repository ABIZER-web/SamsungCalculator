import 'package:flutter/material.dart';
import 'calc_button.dart';

class StandardPad extends StatelessWidget {
  final Function(String) onButtonPressed;

  const StandardPad({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(["C", "( )", "%", "÷"]),
        _buildRow(["7", "8", "9", "x"]),
        _buildRow(["4", "5", "6", "-"]),
        _buildRow(["1", "2", "3", "+"]),
        _buildRow(["+/-", "0", ".", "="]),
      ],
    );
  }

  Widget _buildRow(List<String> labels) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels.map((label) {
          // --- COLOR LOGIC (Samsung Style) ---

          // DEFAULT: Dark Grey BG, White Text
          Color bgColor = const Color(0xFF2E2E2E);
          Color txtColor = Colors.white;
          FontWeight weight = FontWeight.w400;
          double size = 32;

          if (label == "C") {
            // Clear: Dark BG, Red Text
            txtColor = const Color(0xFFFF5A4F);
            size = 28;
          } else if (label == "( )" || label == "%") {
            // Brackets/Percent: Dark BG, Green Text
            txtColor = const Color(0xFF26C045);
            size = 28;
          } else if (["÷", "x", "-", "+"].contains(label)) {
            // Operators: Light Grey BG, Black Text
            bgColor = const Color(0xFFD4D4D2); // Light Grey
            txtColor = Colors.black;
            size = 36;
          } else if (label == "=") {
            // Equals: Green BG, White Text
            bgColor = const Color(0xFF26C045);
            size = 36;
          }

          return CalcButton(
            label: label,
            backgroundColor: bgColor,
            textColor: txtColor,
            fontSize: size,
            fontWeight: weight,
            onTap: () => onButtonPressed(label),
          );
        }).toList(),
      ),
    );
  }
}