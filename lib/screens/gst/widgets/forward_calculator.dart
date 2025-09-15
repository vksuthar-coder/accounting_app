import 'package:flutter/material.dart';
import '/providers/gst_provider.dart';
import 'result_tile.dart';

class ForwardCalculator extends StatelessWidget {
  final TextEditingController amountController;
  final GstState gstState;
  final Function(double amount) onCalculate;

  const ForwardCalculator({
    super.key,
    required this.amountController,
    required this.gstState,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Forward Calculator (Base → Total)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Enter Base Amount (₹)",
            prefixIcon: Icon(Icons.edit),
          ),
          onSubmitted: (_) {
            final amount = double.tryParse(amountController.text) ?? 0;
            onCalculate(amount);
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            final amount = double.tryParse(amountController.text) ?? 0;
            onCalculate(amount);
          },
          icon: const Icon(Icons.calculate),
          label: const Text("Calculate Forward"),
        ),
        if (gstState.baseAmount != null ||
            gstState.gstAmount != null ||
            gstState.totalAmount != null)
          Column(
            children: [
              ResultTile("Base Amount", gstState.baseAmount, Colors.blue),
              ResultTile("GST Amount", gstState.gstAmount, Colors.green),
              if (gstState.cgst != null && gstState.sgst != null) ...[
                ResultTile("CGST", gstState.cgst, Colors.orange),
                ResultTile("SGST", gstState.sgst, Colors.orange),
              ],
              ResultTile("Total with GST", gstState.totalAmount, Colors.red),
            ],
          ),
      ],
    );
  }
}
