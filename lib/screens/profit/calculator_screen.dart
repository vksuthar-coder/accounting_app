import 'package:flutter/material.dart';

// ---------------- Result Card ----------------
class CalculationResultCard extends StatelessWidget {
  final double taxableValue;
  final double netGST; // GST after ITC
  final double itcAmount; // ITC claimed on shipping
  final double effectiveIncome;
  final double netProfit;

  const CalculationResultCard({
    Key? key,
    required this.taxableValue,
    required this.netGST,
    required this.itcAmount,
    required this.effectiveIncome,
    required this.netProfit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Taxable Value: ₹${taxableValue.toStringAsFixed(2)}"),
            Text("GST after ITC: ₹${netGST.toStringAsFixed(2)}"),
            Text("ITC Claimed: ₹${itcAmount.toStringAsFixed(2)}"),
            Text("Effective Income: ₹${effectiveIncome.toStringAsFixed(2)}"),
            Text("Net Profit: ₹${netProfit.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}

// ---------------- Calculator Screen ----------------
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _customerPriceController = TextEditingController();
  final _gstController = TextEditingController(text: "18");
  final _settlementController = TextEditingController();
  final _costController = TextEditingController();
  final _shippingController = TextEditingController();

  double? taxableValue, netGST, itcAmount, effectiveIncome, netProfit;
  bool _showResults = false;
  bool _claimITC = false;

  void _calculate() {
    final customerPrice = double.tryParse(_customerPriceController.text) ?? 0.0;
    final gstRate = double.tryParse(_gstController.text) ?? 18.0;
    final settlement = double.tryParse(_settlementController.text) ?? 0.0;
    final cost = double.tryParse(_costController.text) ?? 0.0;
    final shipping = double.tryParse(_shippingController.text) ?? 0.0;

    // GST on product
    final taxable = customerPrice / (1 + gstRate / 100);
    final gstProduct = customerPrice - taxable;

    // GST on shipping
    final gstShipping = shipping * gstRate / 100;

    // ITC claimed (only shipping)
    final itc = _claimITC ? gstShipping : 0.0;

    // Net GST = GST on product - ITC claimed
    final netGSTAmount = gstProduct - itc;

    // Effective income = settlement - net GST
    final effective = settlement - netGSTAmount;

    final profit = effective - cost;

    setState(() {
      taxableValue = taxable;
      netGST = netGSTAmount;
      itcAmount = itc;
      effectiveIncome = effective;
      netProfit = profit;
      _showResults = true;
    });
  }

  void _clearFields() {
    _customerPriceController.clear();
    _gstController.text = "18";
    _settlementController.clear();
    _costController.clear();
    _shippingController.clear();
    _claimITC = false;
    setState(() {
      taxableValue = null;
      netGST = null;
      itcAmount = null;
      effectiveIncome = null;
      netProfit = null;
      _showResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profit Calculator"),
        backgroundColor: const Color.fromARGB(255, 174, 167, 185),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _clearFields,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInputField(_customerPriceController, "Customer Price (₹)"),
              const SizedBox(height: 12),
              _buildInputField(_gstController, "GST Rate (%)"),
              const SizedBox(height: 12),
              _buildInputField(_settlementController, "Settlement Amount (₹)"),
              const SizedBox(height: 12),
              _buildInputField(_costController, "Product Cost (₹)"),
              const SizedBox(height: 12),
              _buildInputField(_shippingController, "Shipping Charges (₹)"),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: _claimITC,
                onChanged: (val) {
                  setState(() {
                    _claimITC = val ?? false;
                  });
                },
                title: const Text("Claim ITC on Shipping GST"),
                activeColor: Colors.deepPurple,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 206, 203, 212),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
                child: const Text("Calculate Profit"),
              ),
              const SizedBox(height: 24),
              if (_showResults && taxableValue != null)
                CalculationResultCard(
                  taxableValue: taxableValue!,
                  netGST: netGST!,
                  itcAmount: itcAmount!,
                  effectiveIncome: effectiveIncome!,
                  netProfit: netProfit!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
