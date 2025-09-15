import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/tax_provider.dart';
import 'widgets/income_list.dart';
import 'widgets/deduction_list.dart';
import 'widgets/summary_section.dart';


class IncomeTaxScreen extends ConsumerWidget {
  const IncomeTaxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taxState = ref.watch(taxProvider);
    final taxNotifier = ref.read(taxProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Income Tax Calculator')),
      body: taxState.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IncomeList(taxState: taxState, taxNotifier: taxNotifier),
                  const Divider(height: 32),
                  DeductionList(taxState: taxState, taxNotifier: taxNotifier),
                  const Divider(height: 32),
                  SummarySection(taxState: taxState),
                ],
              ),
            ),
    );
  }
}
