import 'package:flutter/material.dart';

class DisplayArea extends StatelessWidget {
  final TextEditingController controller;
  final String liveResult;
  final double fontSize;

  const DisplayArea({
    super.key,
    required this.controller,
    required this.liveResult,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      alignment: Alignment.bottomRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // EDITABLE TEXT FIELD
          TextField(
            controller: controller,
            textAlign: TextAlign.right,
            showCursor: true,
            readOnly: true, // Prevents keyboard from popping up
            autofocus: true,
            cursorColor: const Color(0xFF26C045), // Green Cursor
            cursorWidth: 3,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize, // Dynamic Font Size
              fontWeight: FontWeight.w300,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 10),

          // LIVE PREVIEW (Grey Text)
          if (liveResult.isNotEmpty)
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                liveResult,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}