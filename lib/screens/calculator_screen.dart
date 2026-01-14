import 'package:flutter/material.dart';

// --- IMPORTS ---
import '../widgets/display_area.dart';
import '../widgets/history_view.dart';
import '../widgets/scientific_pad.dart';
import '../widgets/standard_pad.dart';
import '../utils/math_logic.dart';
import 'unit_converter_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  // Key to control the Scaffold (needed to open Drawer programmatically)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _liveResult = "";
  final List<String> _history = [];
  bool _isScientific = false;
  bool _isResultFinalized = false;
  bool _isDegree = false; // False = Rad (Default), True = Deg

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getFontSize() {
    int length = _controller.text.length;
    if (length > 15) return 32;
    if (length > 10) return 42;
    return 60;
  }

  void _onButtonPressed(String label) {
    setState(() {
      if (label == "C") {
        _controller.clear();
        _liveResult = "";
        _isResultFinalized = false;
      } else if (label == "=") {
        _finalizeResult();
      } else if (label == "⌫") {
        _backspace();
      } else if (label == "( )") {
        _handleSmartBrackets();
      } else if (label == "Rad" || label == "Deg") {
        _isDegree = !_isDegree;
        _calculatePreview();
      } else {
        _insertText(label);
      }
    });
  }

  void _insertText(String label) {
    String textToInsert = label;
    // Map special keys to math symbols
    if (label == "x^y") textToInsert = "^";
    else if (label == "x!") textToInsert = "!";
    else if (label == "2^x") textToInsert = "2^";
    else if (label == "e^x") textToInsert = "e^";
    else if (label == "|x|") textToInsert = "abs(";
    else if (label == "sin⁻¹") textToInsert = "sin⁻¹(";
    else if (label == "cos⁻¹") textToInsert = "cos⁻¹(";
    else if (label == "tan⁻¹") textToInsert = "tan⁻¹(";
    else if (label == "sinh⁻¹") textToInsert = "sinh⁻¹(";
    else if (label == "cosh⁻¹") textToInsert = "cosh⁻¹(";
    else if (label == "tanh⁻¹") textToInsert = "tanh⁻¹(";
    else if (label == "√") textToInsert = "√(";
    else if (label == "³√") textToInsert = "³√(";
    else if (label == "ln") textToInsert = "ln(";
    else if (label == "log") textToInsert = "log(";
    else if (label == "1/x") textToInsert = "^(-1)";
    else if (label == "x^2") textToInsert = "^2";
    else if (label == "x^3") textToInsert = "^3";
    else if (["sin", "cos", "tan", "sinh", "cosh", "tanh"].contains(label)) textToInsert = "$label(";

    String text = _controller.text;
    int selectionStart = _controller.selection.start;
    if (selectionStart == -1) selectionStart = text.length;

    const String operators = "+-x÷%^!";
    bool isNewOperator = operators.contains(textToInsert);

    // If typing right after a result:
    if (_isResultFinalized) {
      if (isNewOperator) {
        // If operator, continue with result
        _isResultFinalized = false;
      } else {
        // If number, start fresh
        _controller.clear();
        text = "";
        selectionStart = 0;
        _isResultFinalized = false;
      }
    }

    // Operator Replacement Logic
    if (isNewOperator && selectionStart > 0) {
      String charBefore = text[selectionStart - 1];
      if ("+-x÷%^".contains(textToInsert) && "+-x÷%^".contains(charBefore)) {
        String replacedText = text.replaceRange(selectionStart - 1, selectionStart, textToInsert);
        _controller.text = replacedText;
        _controller.selection = TextSelection.fromPosition(TextPosition(offset: selectionStart));
        _calculatePreview();
        return;
      }
    }

    // Digit Limit Check
    if (!isNewOperator && !textToInsert.contains(RegExp(r'[a-zA-Z\(\)!]'))) {
      String lastOperand = text.split(RegExp(r'[+\-x/÷%^()!]')).last;
      if (lastOperand.length >= 15) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Center(child: Text("Can't enter more than 15 digits.", style: TextStyle(color: Colors.white))), backgroundColor: Color(0xFF333333)),
        );
        return;
      }
    }

    String newText = text.replaceRange(selectionStart, selectionStart, textToInsert);
    _controller.text = newText;
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: selectionStart + textToInsert.length));
    _calculatePreview();
  }

  void _backspace() {
    String text = _controller.text;
    if (text.isEmpty) return;
    int cursor = _controller.selection.start;
    if (cursor == -1) cursor = text.length;
    if (cursor > 0) {
      _controller.text = text.replaceRange(cursor - 1, cursor, "");
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: cursor - 1));
    }
    _isResultFinalized = false;
    _calculatePreview();
  }

  void _handleSmartBrackets() {
    _isResultFinalized = false;
    String text = _controller.text;
    int open = text.split('(').length - 1;
    int closed = text.split(')').length - 1;
    String lastChar = text.isNotEmpty ? text[text.length-1] : "";
    if (open > closed && text.isNotEmpty && !"(-+x÷^".contains(lastChar)) {
      _insertText(")");
    } else {
      _insertText("(");
    }
  }

  void _calculatePreview() {
    String result = MathLogic.calculate(_controller.text, isDegree: _isDegree);
    setState(() {
      _liveResult = (result == _controller.text) ? "" : result;
    });
  }

  void _finalizeResult() {
    if (_liveResult.isNotEmpty && _liveResult != "Error") {
      setState(() {
        _history.insert(0, "${_controller.text} = $_liveResult");
        _controller.text = _liveResult;
        _controller.selection = TextSelection.fromPosition(TextPosition(offset: _liveResult.length));
        _liveResult = "";
        _isResultFinalized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign Key to Scaffold
      backgroundColor: Colors.black,

      // --- LEFT SIDE DRAWER (HISTORY) ---
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E1E1E), // Dark Sidebar Background
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              "History",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.grey),
            Expanded(
              // Using existing HistoryView widget
              child: HistoryView(
                history: _history,
                onClear: () => setState(() => _history.clear()),
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. DISPLAY AREA
            Expanded(
              flex: _isScientific ? 2 : 3,
              child: Stack(
                children: [
                  DisplayArea(
                    controller: _controller,
                    liveResult: _liveResult,
                    fontSize: _getFontSize(),
                  ),
                  // Rad/Deg Indicator
                  Positioned(
                    top: 10,
                    left: 20,
                    child: Text(
                      _isDegree ? "DEG" : "RAD",
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // 2. TOOLBAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // History Button -> Opens Drawer
                  IconButton(
                    icon: const Icon(Icons.access_time, color: Colors.grey),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  // Unit Converter Button
                  IconButton(
                    icon: const Icon(Icons.straighten, color: Colors.grey),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UnitConverterScreen()),
                      );
                    },
                  ),
                  // Scientific Toggle Button
                  IconButton(
                    icon: Icon(Icons.calculate_outlined, color: _isScientific ? const Color(0xFF26C045) : Colors.grey),
                    onPressed: () => setState(() => _isScientific = !_isScientific),
                  ),
                  // Backspace Button
                  IconButton(
                    icon: const Icon(Icons.backspace_outlined, color: Color(0xFF26C045)),
                    onPressed: () => _onButtonPressed("⌫"),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey, thickness: 0.5),

            // 3. KEYPADS
            Expanded(
              flex: _isScientific ? 6 : 5,
              child: Column(
                children: [
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    child: _isScientific
                        ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ScientificPad(onButtonPressed: _onButtonPressed),
                    )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(
                    child: StandardPad(onButtonPressed: _onButtonPressed),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}