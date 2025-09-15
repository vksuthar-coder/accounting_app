// lib/screens/a profit/a_calculator_screen.dart
import 'package:flutter/material.dart';

class ProfitCalculatorScreen extends StatefulWidget {
  const ProfitCalculatorScreen({super.key});

  @override
  State<ProfitCalculatorScreen> createState() => _ProfitCalculatorScreenState();
}

class _ProfitCalculatorScreenState extends State<ProfitCalculatorScreen> {
  final _salePriceController = TextEditingController();
  final _gstRateController = TextEditingController(text: "18");
  final _shippingController = TextEditingController();
  final _productCostController = TextEditingController();

  double? taxableValue,
      outputGst,
      inputGst,
      netGst,
      netRevenueBeforeCost,
      netProfit;

  void _calculate() {
    final double? salePrice = double.tryParse(_salePriceController.text);
    final double? gstRate = double.tryParse(_gstRateController.text);
    final double? shippingInclGst = double.tryParse(_shippingController.text);
    final double? productCost = double.tryParse(_productCostController.text);

    if (salePrice == null || gstRate == null || shippingInclGst == null || productCost == null) {
      setState(() {
        taxableValue = outputGst = inputGst = netGst = netRevenueBeforeCost = netProfit = null;
      });
      return;
    }

    // Step 1: Break sale price
    outputGst = (salePrice * gstRate) / (100 + gstRate);
    taxableValue = salePrice - outputGst!;

    // Step 2: Break shipping (inclusive of GST)
    inputGst = (shippingInclGst * gstRate) / (100 + gstRate);

    // Step 3: Net GST
    netGst = outputGst! - inputGst!;

    // Step 4: Net revenue before product cost
    netRevenueBeforeCost = salePrice - shippingInclGst - netGst!;

    // Step 5: Final Profit
    netProfit = netRevenueBeforeCost! - productCost;

    setState(() {});
  }

  void _clearFields() {
    _salePriceController.clear();
    _gstRateController.text = "18"; // reset to default
    _shippingController.clear();
    _productCostController.clear();

    setState(() {
      taxableValue = outputGst = inputGst = netGst = netRevenueBeforeCost = netProfit = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profit Calculator"),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: "Clear",
            onPressed: _clearFields,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _salePriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Sale Price (incl. GST)",
              ),
            ),
            TextField(
              controller: _gstRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "GST Rate (%)",
              ),
            ),
            TextField(
              controller: _shippingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Shipping Charge (incl. GST)",
              ),
            ),
            TextField(
              controller: _productCostController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Product Cost",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text("Calculate"),
            ),
            const SizedBox(height: 20),
            if (netProfit != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Taxable Value: ₹${taxableValue!.toStringAsFixed(2)}"),
                  Text("Output GST: ₹${outputGst!.toStringAsFixed(2)}"),
                  Text("Input GST (Shipping): ₹${inputGst!.toStringAsFixed(2)}"),
                  Text("Net GST Payable: ₹${netGst!.toStringAsFixed(2)}"),
                  Text("Net Revenue (before cost): ₹${netRevenueBeforeCost!.toStringAsFixed(2)}"),
                  Text("Net Profit: ₹${netProfit!.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              )
          ],
        ),
      ),
    );
  }
}
