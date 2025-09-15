import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/gst_provider.dart';
import '/screens/gst/widgets/gst_widgets.dart';

class GstFunctionsScreen extends ConsumerStatefulWidget {
  const GstFunctionsScreen({super.key});

  @override
  ConsumerState<GstFunctionsScreen> createState() => _GstFunctionsScreenState();
}

class _GstFunctionsScreenState extends ConsumerState<GstFunctionsScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _gstController =
      TextEditingController(text: "18");
  final TextEditingController _totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final gstState = ref.watch(gstProvider);
    final gstNotifier = ref.read(gstProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("GST Calculator"),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: "Clear All",
            onPressed: () {
              gstNotifier.clear();
              _amountController.clear();
              _totalController.clear();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GstRateInput(
              controller: _gstController,
              gstState: gstState,
              onRateChanged: (rate) => gstNotifier.updateGstRate(rate),
            ),

            const Divider(height: 30, thickness: 1.2),

            ForwardCalculator(
              amountController: _amountController,
              gstState: gstState,
              onCalculate: (amount) => gstNotifier.calculateForward(amount),
            ),

            const Divider(height: 30, thickness: 1.2),

            ReverseCalculator(
              totalController: _totalController,
              gstState: gstState,
              onCalculate: (total) => gstNotifier.calculateReverse(total),
            ),

            const Divider(height: 30, thickness: 1.5),

            if (gstState.history.isNotEmpty)
              HistoryList(history: gstState.history),
          ],
        ),
      ),
    );
  }
}
