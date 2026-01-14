import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/unit_data.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  // CATEGORIES
  final List<String> _categories = [
    'Area', 'Length', 'Temperature', 'Volume', 'Mass', 'Data', 'Speed', 'Time',
    'Date', 'Tip', 'Currency', 'Discount', 'GST', 'Numeral System', 'BMI', 'Finance'
  ];
  String _currentCategory = 'Area';

  String _fromUnit = 'Acres';
  String _toUnit = 'Square metres';

  String _topInput = "";
  String _bottomInput = "";
  bool _isTopFocused = true;
  bool _showCursor = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startCursorTimer();
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    super.dispose();
  }

  void _startCursorTimer() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _showCursor = !_showCursor;
      });
    });
  }

  bool _canAppendInput(String currentText, String newChar) {
    if (_currentCategory == 'Numeral System') return true;

    String predictedText = currentText + newChar;
    String cleanNumber = predictedText.replaceAll('.', '');

    if (cleanNumber.length > 15) {
      _showSnack("Can't enter more than 15 digits.");
      return false;
    }
    if (predictedText.contains('.')) {
      List<String> parts = predictedText.split('.');
      if (parts.length > 1 && parts[1].length > 10) {
        _showSnack("Can't enter more than 10 decimal places.");
        return false;
      }
    }
    return true;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(msg, style: const TextStyle(color: Colors.white))),
        backgroundColor: const Color(0xFF333333),
        behavior: SnackBarBehavior.floating,
        width: 320,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _validateUnits() {
    if (['Tip', 'Discount', 'GST', 'BMI', 'Finance'].contains(_currentCategory)) return;

    if (_fromUnit == _toUnit) {
      final allUnits = UnitData.conversionRates[_currentCategory]!.keys.toList();
      int currentIndex = allUnits.indexOf(_toUnit);
      int nextIndex = (currentIndex + 1) % allUnits.length;
      _toUnit = allUnits[nextIndex];
    }
  }

  void _changeCategory(String category) {
    setState(() {
      _currentCategory = category;
      _topInput = "";
      _bottomInput = "";
      _isTopFocused = true;

      // DEFAULTS
      if (category == 'Tip') {
        _fromUnit = '15%'; _toUnit = 'Tip Amount';
      } else if (category == 'Discount') {
        _fromUnit = '10%'; _toUnit = 'Final Price';
      } else if (category == 'GST') {
        _fromUnit = '18%'; _toUnit = 'Total Amount';
      } else if (category == 'Currency') {
        _fromUnit = 'USD'; _toUnit = 'INR';
      } else if (category == 'Numeral System') {
        _fromUnit = 'Decimal'; _toUnit = 'Binary';
      } else if (category == 'BMI') {
        _fromUnit = '170 cm'; _toUnit = 'BMI Score';
      } else if (category == 'Finance') {
        _fromUnit = '10%'; _toUnit = 'Total Amount';
      } else if (category == 'Date') {
        _fromUnit = 'Years'; _toUnit = 'Months';
      } else {
        var units = UnitData.conversionRates[category]?.keys;
        if (units != null && units.isNotEmpty) {
          _fromUnit = units.first;
          _toUnit = units.skip(1).first;
        }
      }
      _validateUnits();
    });
  }

  void _onKeyPressed(String label) {
    setState(() {
      _showCursor = true;

      if (label == "C") {
        _topInput = ""; _bottomInput = "";
      } else if (label == "⌫") {
        if (_isTopFocused) {
          if (_topInput.isNotEmpty) {
            _topInput = _topInput.substring(0, _topInput.length - 1);
            _calculateFromTop();
          } else { _topInput = ""; _bottomInput = ""; }
        } else {
          if (_bottomInput.isNotEmpty) {
            _bottomInput = _bottomInput.substring(0, _bottomInput.length - 1);
            _calculateFromBottom();
          } else { _topInput = ""; _bottomInput = ""; }
        }
      } else if (label == "↑") {
        _isTopFocused = true;
      } else if (label == "↓") {
        _isTopFocused = false;
      } else if (label == ".") {
        String activeInput = _isTopFocused ? _topInput : _bottomInput;
        if (!activeInput.contains(".")) {
          if (_canAppendInput(activeInput, ".")) {
            if (_isTopFocused) _topInput = activeInput.isEmpty ? "0." : activeInput + ".";
            else _bottomInput = activeInput.isEmpty ? "0." : activeInput + ".";
          }
        }
      } else {
        String activeInput = _isTopFocused ? _topInput : _bottomInput;
        if (_canAppendInput(activeInput, label)) {
          if (_isTopFocused) {
            _topInput += label;
            _calculateFromTop();
          } else {
            _bottomInput += label;
            _calculateFromBottom();
          }
        }
      }
    });
  }

  void _calculateFromTop() {
    if (_topInput.isEmpty) { _bottomInput = ""; return; }

    if (_currentCategory == 'Numeral System') {
      _bottomInput = UnitData.convertNumeral(_topInput, _fromUnit, _toUnit);
      return;
    }

    double input = double.tryParse(_topInput) ?? 0.0;
    double result = UnitData.convert(input, _fromUnit, _toUnit, _currentCategory);
    _bottomInput = _formatResult(result);
  }

  void _calculateFromBottom() {
    if (_bottomInput.isEmpty) { _topInput = ""; return; }

    if (_currentCategory == 'Numeral System') {
      _topInput = UnitData.convertNumeral(_bottomInput, _toUnit, _fromUnit);
      return;
    }

    double input = double.tryParse(_bottomInput) ?? 0.0;
    String reverseTarget = 'Reverse';
    if (!['BMI', 'Finance', 'Tip', 'Discount', 'GST'].contains(_currentCategory)) {
      reverseTarget = _fromUnit;
    }

    double result = UnitData.convert(input, _fromUnit, reverseTarget, _currentCategory);
    _topInput = _formatResult(result);
  }

  String _formatResult(double value) {
    if (value == 0) return "";
    if (value % 1 == 0) return value.toInt().toString();
    String s = value.toStringAsFixed(10);
    while (s.contains('.') && (s.endsWith('0') || s.endsWith('.'))) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }

  bool _isUnitLabelHidden() {
    return ['Tip', 'Discount', 'GST', 'Numeral System', 'BMI', 'Finance'].contains(_currentCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Unit converter", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // CATEGORY SCROLLER
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                String cat = _categories[index];
                bool isSelected = cat == _currentCategory;
                return GestureDetector(
                  onTap: () => _changeCategory(cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2E2E2E) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.5),

          // DISPLAY AREA
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDropdown(true),
                  const SizedBox(height: 5),
                  // LEFT ALIGNED INPUT ROW
                  _buildInputRow(_topInput, _isUnitLabelHidden() ? "" : _fromUnit, _isTopFocused),

                  const Divider(color: Colors.grey, height: 40),

                  _buildDropdown(false),
                  const SizedBox(height: 5),
                  // LEFT ALIGNED INPUT ROW
                  _buildInputRow(_bottomInput, _isUnitLabelHidden() ? "" : _toUnit, !_isTopFocused),
                ],
              ),
            ),
          ),

          // KEYPAD
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black,
              child: Column(
                children: [
                  _buildCalcRow(["7", "8", "9", "⌫"]),
                  _buildCalcRow(["4", "5", "6", "C"]),
                  _buildCalcRow(["1", "2", "3", "↑"]),
                  _buildCalcRow(["+/-", "0", ".", "↓"]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UPDATED INPUT ROW: Left Alignment to stop numbers from moving ---
  Widget _buildInputRow(String text, String unitLabel, bool isActive) {
    Color textColor = isActive ? Colors.white : const Color(0xFF26C045);
    if (!isActive && text.isNotEmpty) textColor = const Color(0xFF26C045);

    return Row(
      // Changed to START so numbers build from left to right without the whole block shifting
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft, // Keep text aligned to start
            child: Text(
              text.isEmpty ? "0" : text,
              style: TextStyle(color: textColor, fontSize: 32, fontWeight: isActive ? FontWeight.w300 : FontWeight.bold),
            ),
          ),
        ),
        // Cursor stays next to the last digit
        if (isActive && _showCursor)
          Container(
            width: 2,
            height: 30,
            color: const Color(0xFF26C045),
            margin: const EdgeInsets.symmetric(horizontal: 2),
          ),
        const SizedBox(width: 10),
        Text(
          unitLabel,
          style: TextStyle(color: isActive ? Colors.white70 : const Color(0xFF26C045), fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildDropdown(bool isFrom) {
    List<String> items = [];
    String currentValue = isFrom ? _fromUnit : _toUnit;
    String otherValue = isFrom ? _toUnit : _fromUnit;

    // (Dropdown logic remains the same, omitted for brevity but included in full file context if needed)
    // ... Copy logic from previous step regarding list population ...
    // Re-inserting logic for completeness:
    if (_currentCategory == 'Tip') items = isFrom ? (UnitData.conversionRates['Tip']?.keys.toList() ?? []) : ['Tip Amount', 'Total Bill'];
    else if (_currentCategory == 'Discount') items = isFrom ? (UnitData.conversionRates['Discount']?.keys.toList() ?? []) : ['Final Price', 'You Save'];
    else if (_currentCategory == 'GST') items = isFrom ? (UnitData.conversionRates['GST']?.keys.toList() ?? []) : ['Tax Amount', 'Total Amount'];
    else if (_currentCategory == 'BMI') items = isFrom ? (UnitData.conversionRates['BMI']?.keys.toList() ?? []) : ['BMI Score'];
    else if (_currentCategory == 'Finance') items = isFrom ? (UnitData.conversionRates['Finance']?.keys.toList() ?? []) : ['Interest Earned', 'Total Amount'];
    else {
      List<String> allUnits = UnitData.conversionRates[_currentCategory]?.keys.toList() ?? [];
      items = allUnits.where((unit) => unit == currentValue || unit != otherValue).toList();
    }
    if (items.isEmpty) items = ['Error'];

    return Align(
      alignment: Alignment.centerLeft,
      child: DropdownButton<String>(
        value: items.contains(currentValue) ? currentValue : items.first,
        dropdownColor: const Color(0xFF2E2E2E),
        style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
        underline: Container(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        items: items.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            if (newValue == null) return;
            if (isFrom) {
              _fromUnit = newValue;
              if (_isTopFocused) _calculateFromTop(); else _calculateFromBottom();
            } else {
              _toUnit = newValue;
              if (_isTopFocused) _calculateFromTop(); else _calculateFromBottom();
            }
            _validateUnits();
          });
        },
      ),
    );
  }

  // --- UPDATED KEYPAD: White Buttons & Big Arrows ---
  Widget _buildCalcRow(List<String> labels) {
    return Expanded(
      child: Row(
        children: labels.map((label) {
          Color bgColor = const Color(0xFF2E2E2E); // Default Dark Grey
          Color txtColor = Colors.white;
          double fontSize = 28;
          FontWeight fontWeight = FontWeight.w400;

          // SPECIAL BUTTON STYLING
          if (label == "C") {
            bgColor = Colors.white; // WHITE BG
            txtColor = Colors.red;  // RED TEXT
            fontWeight = FontWeight.bold;
          } else if (label == "⌫") {
            bgColor = Colors.white; // WHITE BG
            txtColor = const Color(0xFF26C045); // GREEN ICON
          } else if (["↑", "↓"].contains(label)) {
            bgColor = Colors.white; // WHITE BG
            txtColor = const Color(0xFF26C045); // GREEN ARROWS
            fontSize = 40; // BIGGER ARROWS
            fontWeight = FontWeight.w900;
          }

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: bgColor,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => _onKeyPressed(label),
                  child: Center(
                    child: label == "⌫"
                        ? Icon(Icons.backspace_outlined, color: txtColor, size: 30)
                        : Text(
                      label,
                      style: TextStyle(fontSize: fontSize, color: txtColor, fontWeight: fontWeight),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}