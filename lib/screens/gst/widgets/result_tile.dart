import 'package:flutter/material.dart';

class ResultTile extends StatelessWidget {
  final String label;
  final double? value;
  final Color color;

  const ResultTile(this.label, this.value, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        trailing: Text(
          value == null ? "-" : "₹ ${value!.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
