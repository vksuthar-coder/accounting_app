// lib/providers/gst_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GstState {
  final double? gstRate;
  final double? baseAmount;
  final double? gstAmount;
  final double? totalAmount;
  final double? reverseBase;
  final double? reverseGst;

  // New fields
  final double? cgst;
  final double? sgst;
  final List<String> history;

  const GstState({
    this.gstRate,
    this.baseAmount,
    this.gstAmount,
    this.totalAmount,
    this.reverseBase,
    this.reverseGst,
    this.cgst,
    this.sgst,
    this.history = const [],
  });

  GstState copyWith({
    double? gstRate,
    double? baseAmount,
    double? gstAmount,
    double? totalAmount,
    double? reverseBase,
    double? reverseGst,
    double? cgst,
    double? sgst,
    List<String>? history,
  }) {
    return GstState(
      gstRate: gstRate ?? this.gstRate,
      baseAmount: baseAmount ?? this.baseAmount,
      gstAmount: gstAmount ?? this.gstAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      reverseBase: reverseBase ?? this.reverseBase,
      reverseGst: reverseGst ?? this.reverseGst,
      cgst: cgst ?? this.cgst,
      sgst: sgst ?? this.sgst,
      history: history ?? this.history,
    );
  }
}

class GstNotifier extends StateNotifier<GstState> {
  GstNotifier() : super(const GstState(gstRate: 18));

  void updateGstRate(double rate) {
    state = state.copyWith(gstRate: rate);
  }

  /// Forward calculation (base -> gst -> total)
  void calculateForward(double amount, {bool split = true, bool round = true}) {
    final rate = state.gstRate ?? 0;
    if (amount <= 0 || rate <= 0) {
      state = state.copyWith(baseAmount: null, gstAmount: null, totalAmount: null);
      return;
    }

    double gst = amount * rate / 100;
    double total = amount + gst;

    if (round) {
      gst = double.parse(gst.toStringAsFixed(2));
      total = double.parse(total.toStringAsFixed(2));
    }

    double? cgst;
    double? sgst;
    if (split) {
      cgst = gst / 2;
      sgst = gst / 2;
    }

    _addToHistory("Forward: Base=$amount, GST=$gst, Total=$total");

    state = state.copyWith(
      baseAmount: amount,
      gstAmount: gst,
      totalAmount: total,
      cgst: cgst,
      sgst: sgst,
    );
  }

  /// Reverse calculation (total -> base + gst)
  void calculateReverse(double total, {bool split = true, bool round = true}) {
    final rate = state.gstRate ?? 0;
    if (total <= 0 || rate <= 0) {
      state = state.copyWith(reverseBase: null, reverseGst: null);
      return;
    }

    double base = total * 100 / (100 + rate);
    double gst = total - base;

    if (round) {
      base = double.parse(base.toStringAsFixed(2));
      gst = double.parse(gst.toStringAsFixed(2));
    }

    double? cgst;
    double? sgst;
    if (split) {
      cgst = gst / 2;
      sgst = gst / 2;
    }

    _addToHistory("Reverse: Total=$total, Base=$base, GST=$gst");

    state = state.copyWith(
      reverseBase: base,
      reverseGst: gst,
      cgst: cgst,
      sgst: sgst,
    );
  }

  /// Inclusive GST calculation (amount is already GST inclusive)
  void calculateInclusive(double total, {bool split = true}) {
    calculateReverse(total, split: split);
  }

  /// Exclusive GST calculation (amount is before GST)
  void calculateExclusive(double base, {bool split = true}) {
    calculateForward(base, split: split);
  }

  /// Clear all values
  void clear() {
    state = const GstState(gstRate: 18);
  }

  /// Private helper to maintain history (last 10 records)
  void _addToHistory(String entry) {
    final updatedHistory = [...state.history];
    updatedHistory.insert(0, entry);
    if (updatedHistory.length > 10) {
      updatedHistory.removeLast();
    }
    state = state.copyWith(history: updatedHistory);
  }
}

final gstProvider = StateNotifierProvider<GstNotifier, GstState>((ref) {
  return GstNotifier();
});
