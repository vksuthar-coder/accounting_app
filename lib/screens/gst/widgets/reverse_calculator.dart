import 'package:flutter/material.dart';
import '/providers/gst_provider.dart';
import 'result_tile.dart';

class ReverseCalculator extends StatelessWidget {
  final TextEditingController totalController;
  final GstState gstState;
  final Function(double total) onCalculate;

  const ReverseCalculator({
    super.key,
    required this.totalController,
    required this.gstState,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Reverse Calculator (Total → Base)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: totalController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Enter Total incl. GST (₹)",
            prefixIcon: Icon(Icons.attach_money),
          ),
          onSubmitted: (_) {
            final total = double.tryParse(totalController.text) ?? 0;
            onCalculate(total);
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            final total = double.tryParse(totalController.text) ?? 0;
            onCalculate(total);
          },
          icon: const Icon(Icons.refresh),
          label: const Text("Calculate Reverse"),
        ),
        if (gstState.reverseBase != null || gstState.reverseGst != null)
          Column(
            children: [
              ResultTile("Base Amount", gstState.reverseBase, Colors.blue),
              ResultTile("GST Portion", gstState.reverseGst, Colors.green),
              if (gstState.cgst != null && gstState.sgst != null) ...[
                ResultTile("CGST", gstState.cgst, Colors.orange),
                ResultTile("SGST", gstState.sgst, Colors.orange),
              ],
            ],
          ),
      ],
    );
  }
}
