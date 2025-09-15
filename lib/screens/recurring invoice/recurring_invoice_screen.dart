// lib/screens/recurring_invoice_screen.dart
import 'package:flutter/material.dart';

class RecurringInvoiceScreen extends StatefulWidget {
  const RecurringInvoiceScreen({super.key});

  @override
  State<RecurringInvoiceScreen> createState() => _RecurringInvoiceScreenState();
}

class _RecurringInvoiceScreenState extends State<RecurringInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _gstPercentController = TextEditingController(text: "18");
  String _recurrence = "Monthly";

  double totalAmount = 0;
  double gstAmount = 0;

  final List<String> recurrenceOptions = ["Daily", "Weekly", "Monthly", "Yearly"];

  void _calculateInvoice() {
    if (_formKey.currentState!.validate()) {
      final double price = double.tryParse(_priceController.text) ?? 0;
      final double quantity = double.tryParse(_quantityController.text) ?? 0;
      final double gstPercent = double.tryParse(_gstPercentController.text) ?? 0;

      final subtotal = price * quantity;
      final gst = subtotal * gstPercent / 100;

      setState(() {
        totalAmount = subtotal + gst;
        gstAmount = gst;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recurring Invoice"),
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
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _gstPercentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "GST % (optional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _recurrence,
                    decoration: const InputDecoration(
                      labelText: "Recurrence",
                      border: OutlineInputBorder(),
                    ),
                    items: recurrenceOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _recurrence = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _calculateInvoice,
                    child: const Text("Calculate Recurring Invoice"),
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
                              "Recurring Invoice Preview",
                              style: theme.textTheme.titleMedium,
                            ),
                            const Divider(),
                            Text("Customer: ${_customerNameController.text}"),
                            Text("Product: ${_productNameController.text}"),
                            Text(
                                "Quantity: ${_quantityController.text}, Price: ₹${_priceController.text}"),
                            Text("GST: ₹${gstAmount.toStringAsFixed(2)}"),
                            Text("Recurrence: $_recurrence"),
                            const SizedBox(height: 8),
                            Text(
                              "Total Amount: ₹${totalAmount.toStringAsFixed(2)}",
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
