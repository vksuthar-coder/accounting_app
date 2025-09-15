import 'package:flutter/material.dart';
import '/providers/gst_provider.dart';

class GstRateInput extends StatelessWidget {
  final TextEditingController controller;
  final GstState gstState;
  final Function(double rate) onRateChanged;

  const GstRateInput({
    super.key,
    required this.controller,
    required this.gstState,
    required this.onRateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "GST Rate (%)",
            prefixIcon: Icon(Icons.percent),
          ),
          onChanged: (val) {
            final rate = double.tryParse(val);
            if (rate != null) onRateChanged(rate);
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [0, 5, 12, 18, 28].map((rate) {
            return ChoiceChip(
              label: Text("$rate%"),
              selected: gstState.gstRate?.toInt() == rate,
              onSelected: (_) {
                controller.text = rate.toString();
                onRateChanged(rate.toDouble());
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
