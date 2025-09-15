import 'package:flutter/material.dart';
import '/providers/tax_provider.dart';

class SummarySection extends StatelessWidget {
  final TaxState taxState;

  const SummarySection({super.key, required this.taxState});

  @override
  Widget build(BuildContext context) {
    // Standard Deduction
    const double standardDeduction = 75000;
    // Section 87A rebate (applied only if taxable income <= 12 lakh)
    double rebate = taxState.taxableIncome <= 1200000 ? 25000 : 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildRow('Total Income', taxState.totalIncome),
            _buildRow('Total Deductions', taxState.totalDeductions),
            _buildRow('Standard Deduction', standardDeduction),
            const Divider(height: 24, thickness: 1),
            _buildRow('Taxable Income', taxState.taxableIncome),
            if (rebate > 0) _buildRow('Section 87A Rebate', rebate),
            const Divider(height: 24, thickness: 1),
            Text(
              'Income Tax Payable: ₹${taxState.calculateTax().toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('₹${amount.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
