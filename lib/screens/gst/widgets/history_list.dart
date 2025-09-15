import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final List<String> history;

  const HistoryList({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Calculation History",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: Text(history[index]),
              ),
            );
          },
        ),
      ],
    );
  }
}
