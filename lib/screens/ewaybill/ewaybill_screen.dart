// lib/screens/ewaybill_screen.dart
import 'package:flutter/material.dart';

class EWayBillScreen extends StatefulWidget {
  const EWayBillScreen({super.key});

  @override
  State<EWayBillScreen> createState() => _EWayBillScreenState();
}

class _EWayBillScreenState extends State<EWayBillScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _invoiceNumberController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _fromAddressController = TextEditingController();
  final TextEditingController _toAddressController = TextEditingController();
  final TextEditingController _productDetailsController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _taxableAmountController = TextEditingController();

  String transportMode = "Road";
  final List<String> transportModes = ["Road", "Rail", "Air", "Ship"];

  double totalAmount = 0;

  void _calculateEWayBill() {
    if (_formKey.currentState!.validate()) {
      final double quantity = double.tryParse(_quantityController.text) ?? 0;
      final double taxableAmount = double.tryParse(_taxableAmountController.text) ?? 0;

      setState(() {
        totalAmount = quantity * taxableAmount; // simple calculation for demo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Way Bill"),
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
                    controller: _invoiceNumberController,
                    decoration: const InputDecoration(
                      labelText: "Invoice Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter invoice number" : null,
                  ),
                  const SizedBox(height: 12),
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
                    controller: _fromAddressController,
                    decoration: const InputDecoration(
                      labelText: "From Address",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter from address" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _toAddressController,
                    decoration: const InputDecoration(
                      labelText: "To Address",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter to address" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _productDetailsController,
                    decoration: const InputDecoration(
                      labelText: "Product Details",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter product details" : null,
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
                          controller: _taxableAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Taxable Amount per Unit",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? "Enter amount" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: transportMode,
                    decoration: const InputDecoration(
                      labelText: "Transport Mode",
                      border: OutlineInputBorder(),
                    ),
                    items: transportModes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        transportMode = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _calculateEWayBill,
                    child: const Text("Generate E-Way Bill"),
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
                              "E-Way Bill Preview",
                              style: theme.textTheme.titleMedium,
                            ),
                            const Divider(),
                            Text("Invoice Number: ${_invoiceNumberController.text}"),
                            Text("Customer: ${_customerNameController.text}"),
                            Text("From: ${_fromAddressController.text}"),
                            Text("To: ${_toAddressController.text}"),
                            Text("Product: ${_productDetailsController.text}"),
                            Text(
                                "Quantity: ${_quantityController.text}, Taxable Amount: ₹${_taxableAmountController.text}"),
                            Text("Transport Mode: $transportMode"),
                            const SizedBox(height: 8),
                            Text(
                              "Total Value: ₹${totalAmount.toStringAsFixed(2)}",
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
