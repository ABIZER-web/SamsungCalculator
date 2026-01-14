import 'package:flutter/material.dart';
import 'calc_button.dart';

class ScientificPad extends StatefulWidget {
  final Function(String) onButtonPressed;

  const ScientificPad({super.key, required this.onButtonPressed});

  @override
  State<ScientificPad> createState() => _ScientificPadState();
}

class _ScientificPadState extends State<ScientificPad> {
  bool _isInverted = false; // Tracks if we are on Page 2 (Shifted)

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _isInverted ? _buildPage2() : _buildPage1(),
    );
  }

  // PAGE 1: Standard Scientific
  Widget _buildPage1() {
    return Column(
      key: const ValueKey(1),
      children: [
        _buildRow(["⇅", "Rad", "√", "|x|"]),
        _buildRow(["sin", "cos", "tan", "π"]),
        _buildRow(["ln", "log", "1/x", "e"]),
        _buildRow(["e^x", "x^2", "x^y"]), // Row with 3 buttons expands nicely
      ],
    );
  }

  // PAGE 2: Inverted Functions
  Widget _buildPage2() {
    return Column(
      key: const ValueKey(2),
      children: [
        _buildRow(["⇅", "Rad", "³√", "2^x"]),
        _buildRow(["sin⁻¹", "cos⁻¹", "tan⁻¹", "x^3"]),
        _buildRow(["sinh", "cosh", "tanh"]),
        _buildRow(["sinh⁻¹", "cosh⁻¹", "tanh⁻¹", "x!"]),
      ],
    );
  }

  Widget _buildRow(List<String> labels) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels.map((label) {
          // Scientific Buttons: Darker Grey, Smaller Text
          Color txtColor = Colors.white;
          if (label == "⇅") txtColor = const Color(0xFF26C045); // Green toggle arrow

          return CalcButton(
            label: label,
            backgroundColor: const Color(0xFF2E2E2E),
            textColor: txtColor,
            fontSize: 20, // Smaller font for scientific terms
            onTap: () {
              if (label == "⇅") {
                setState(() => _isInverted = !_isInverted);
              } else {
                widget.onButtonPressed(label);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}