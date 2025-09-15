// lib/screens/billing_screen.dart
import 'package:flutter/material.dart';
import '/screens/invoice/gst_invoice_screen.dart';
import '/screens/performa/proforma_screen.dart';
import '/screens/recurring invoice/recurring_invoice_screen.dart';
import '/screens/ewaybill/ewaybill_screen.dart';
import '/screens/profit/calculator_screen.dart';
import '/screens/a profit/a_calculator_screen.dart'; // new A Calculator import

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  Widget _buildTile(
    BuildContext context,
    String title, {
    IconData icon = Icons.receipt_long,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: theme.colorScheme.primary.withOpacity(0.1),
          highlightColor: theme.colorScheme.primary.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: isDark
                  ? null
                  : Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (iconColor ?? theme.colorScheme.primary)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoicing & Billing"),
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Text(
              "Manage Your Documents",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Text(
              "Create and manage all your billing documents",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _buildTile(
                  context,
                  "GST-compliant Invoice",
                  icon: Icons.receipt,
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GstInvoiceScreen()),
                    );
                  },
                ),
                _buildTile(
                  context,
                  "Proforma Invoices & Estimates",
                  icon: Icons.description_outlined,
                  iconColor: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProformaScreen()),
                    );
                  },
                ),
                _buildTile(
                  context,
                  "Recurring Invoices",
                  icon: Icons.repeat,
                  iconColor: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RecurringInvoiceScreen()),
                    );
                  },
                ),
                _buildTile(
                  context,
                  "E-Way Bill Integration",
                  icon: Icons.local_shipping_outlined,
                  iconColor: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EWayBillScreen()),
                    );
                  },
                ),
                _buildTile(
                  context,
                  "Profit Calculator",
                  icon: Icons.calculate,
                  iconColor: Colors.red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalculatorScreen()),
                    );
                  },
                ),
                // New A Calculator tile
                _buildTile(
                  context,
                  "A Calculator",
                  icon: Icons.calculate_outlined,
                  iconColor: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfitCalculatorScreen()), // replace with A Calculator screen class
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
