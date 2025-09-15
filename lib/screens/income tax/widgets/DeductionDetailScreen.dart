import 'package:flutter/material.dart';

class DeductionDetailScreen extends StatelessWidget {
  const DeductionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deductions - Old Tax Regime'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Understanding Deductions in Old Tax Regime',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'In the old tax regime, taxpayers can reduce their taxable income by claiming various deductions. '
              'These deductions lower the amount of income that is subject to tax, helping you reduce your overall tax liability.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              '1. Section 80C - Investments and Savings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'You can claim deductions up to ₹1,50,000 per year for investments such as: \n'
              '- Employee Provident Fund (EPF)\n'
              '- Life Insurance Premiums\n'
              '- Equity Linked Saving Schemes (ELSS)\n'
              '- Tuition fees for children\n'
              '- Principal repayment of home loan',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              '2. Section 80D - Health Insurance Premiums',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'You can claim deductions for premiums paid for health insurance policies for yourself, spouse, children, and parents. '
              'Limits vary based on age and coverage.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              '3. Section 24(b) - Home Loan Interest',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Interest paid on home loans for a self-occupied property can be claimed as a deduction up to ₹2,00,000 per year.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              '4. House Rent Allowance (HRA)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'If you live in a rented house and receive HRA from your employer, you can claim exemption on HRA under certain conditions.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              '5. Other Deductions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Other deductions include: \n'
              '- Section 80E: Education loan interest\n'
              '- Section 80G: Donations to charitable institutions\n'
              '- Section 80TTA/80TTB: Interest on savings accounts and deposits',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              'Note:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'All these deductions are available only in the old tax regime. In the new tax regime, most of these are not allowed, '
              'except for a few specific deductions like NPS employer contribution and standard deduction for salaried individuals.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            Text(
              'By using deductions wisely in the old tax regime, you can significantly reduce your taxable income and thus your tax liability.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
