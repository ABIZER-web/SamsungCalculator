import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

class MathLogic {
  // We add 'isDegree' to know if we should calculate in Degrees or Radians
  static String calculate(String input, {bool isDegree = false}) {
    if (input.isEmpty) return "";

    try {
      // 1. PREPARE THE EXPRESSION
      String finalInput = input
          .replaceAll('x', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '/100')
          .replaceAll('π', '${math.pi}')
          .replaceAll('e', '${math.e}')
      // Fix Roots
          .replaceAll('√', 'sqrt')
          .replaceAll('³√', 'nrt(3,') // Cube root
      // Fix Factorial
          .replaceAll('!', '!')
      // Fix Logarithms
          .replaceAll('ln(', 'ln(')
          .replaceAllMapped(RegExp(r'log\(([^)]+)\)'), (Match m) => 'log(10, ${m.group(1)})');

      // 2. HANDLE DEGREE CONVERSION (Crucial Step)
      // If in Degree Mode, we must wrap numbers in conversion factors
      if (isDegree) {
        // Convert INPUTS to Radians for normal trig: sin(90) -> sin(90 * pi/180)
        finalInput = finalInput.replaceAllMapped(
            RegExp(r'(sin|cos|tan|sinh|cosh|tanh)\(([^)]+)\)'),
                (Match m) => '${m.group(1)}((${m.group(2)}) * (${math.pi} / 180))'
        );
      }

      // 3. HANDLE INVERSE TRIG (asin, acos, atan)
      // We map human text "sin⁻¹" to math function "arcsin"
      finalInput = finalInput
          .replaceAll('sin⁻¹', 'arcsin')
          .replaceAll('cos⁻¹', 'arccos')
          .replaceAll('tan⁻¹', 'arctan')
          .replaceAll('sinh⁻¹', 'arcsinh')
          .replaceAll('cosh⁻¹', 'arccosh')
          .replaceAll('tanh⁻¹', 'arctanh');

      // 4. PARSE & EVALUATE
      Parser p = Parser();
      Expression exp = p.parse(finalInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // 5. CONVERT RESULT BACK TO DEGREES (For Inverse Trig)
      // If we did arcsin(0.5), we get 0.523 rads. If Degree Mode, we want 30 degrees.
      // Note: This simple check assumes the *entire* result is an angle if it contains arc-functions.
      // For a complex calculator, this is tricky, but for standard "sin⁻¹(0.5)" this works.
      if (isDegree && (input.contains('⁻¹'))) {
        eval = eval * (180 / math.pi);
      }

      // 6. FORMAT OUTPUT
      return _formatNumber(eval);
    } catch (e) {
      return "Error";
    }
  }

  static String _formatNumber(double value) {
    if (value.isInfinite || value.isNaN) return "Error";

    // Tiny/Huge numbers -> Scientific Notation
    if (value.abs() >= 1e15 || (value.abs() > 0 && value.abs() < 1e-9)) {
      return value.toStringAsExponential(6).toUpperCase();
    }

    // Clean integers (e.g. 5.0 -> 5)
    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    // Reasonable decimal precision
    return value.toStringAsFixed(8).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }
}