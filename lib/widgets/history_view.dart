import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  final List<String> history;
  final VoidCallback onClear;

  const HistoryView({
    super.key,
    required this.history,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: history.isEmpty
                ? const Center(child: Text("No history", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                List<String> parts = history[index].split(' = ');
                String equation = parts[0];
                String result = parts.length > 1 ? parts[1] : "";
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(equation, style: const TextStyle(color: Colors.white70, fontSize: 18)),
                      const SizedBox(height: 5),
                      Text("= $result", style: TextStyle(color: const Color(0xFF26C045), fontSize: 26, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),
          if (history.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20, top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E2E),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text("Clear history", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}