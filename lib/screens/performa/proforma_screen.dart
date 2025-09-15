// lib/screens/proforma_screen.dart
import 'package:flutter/material.dart';

class ProformaScreen extends StatefulWidget {
  const ProformaScreen({super.key});

  @override
  State<ProformaScreen> createState() => _ProformaScreenState();
}

class _ProformaScreenState extends State<ProformaScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  double totalAmount = 0;

  void _calculateEstimate() {
    if (_formKey.currentState!.validate()) {
      final double price = double.tryParse(_priceController.text) ?? 0;
      final double quantity = double.tryParse(_quantityController.text) ?? 0;

      setState(() {
        totalAmount = price * quantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Proforma Invoice / Estimate"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _customerNameController,
                    decoration: const InputDecoration(
                      labelText: "Customer Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter customer name" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _productNameController,
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter product name" : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Quantity",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? "Enter quantity" : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Price per unit",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? "Enter price" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _calculateEstimate,
                    child: const Text("Calculate Estimate"),
                  ),
                  const SizedBox(height: 20),
                  if (totalAmount > 0)
                    Card(
                      color: theme.colorScheme.surfaceVariant,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Proforma Invoice Preview",
                              style: theme.textTheme.titleMedium,
                            ),
                            const Divider(),
                            Text("Customer: ${_customerNameController.text}"),
                            Text("Product: ${_productNameController.text}"),
                            Text(
                                "Quantity: ${_quantityController.text}, Price: ₹${_priceController.text}"),
                            const SizedBox(height: 8),
                            Text(
                              "Total Estimate: ₹${totalAmount.toStringAsFixed(2)}",
                              style: theme.textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
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
