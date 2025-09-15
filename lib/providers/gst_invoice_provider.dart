import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StateNotifierProvider for managing GST Invoice state
final gstInvoiceProvider =
    StateNotifierProvider<GstInvoiceNotifier, GstInvoice?>(
  (ref) => GstInvoiceNotifier(),
);

class GstInvoiceNotifier extends StateNotifier<GstInvoice?> {
  int _invoiceCounter = 1;

  GstInvoiceNotifier() : super(null);

  /// Generate a new GST invoice
  void generateInvoice({
    // Seller
    required String sellerName,
    required String sellerAddress,
    required String sellerGstin,

    // Buyer
    required String buyerName,
    required String buyerAddress,
    String buyerGstin = '',
    required String placeOfSupply,

    // Invoice
    required String invoiceNumber,
    required String invoiceDate,
    String? orderNumber,
    String? orderDate,

    // Item
    required String description,
    required String hsnCode,
    required double quantity,
    required double unitPrice,
    double discount = 0.0,

    // Taxes
    double cgstPercent = 9,
    double sgstPercent = 9,
    double igstPercent = 0,
  }) {
    final baseAmount = (unitPrice * quantity) - discount;

    final cgstAmount = baseAmount * cgstPercent / 100;
    final sgstAmount = baseAmount * sgstPercent / 100;
    final igstAmount = baseAmount * igstPercent / 100;

    final totalAmount = baseAmount + cgstAmount + sgstAmount + igstAmount;

    state = GstInvoice(
      invoiceCounter: _invoiceCounter++,
      invoiceNumber: invoiceNumber,
      invoiceDate: invoiceDate,
      orderNumber: orderNumber,
      orderDate: orderDate,

      // Seller
      sellerName: sellerName,
      sellerAddress: sellerAddress,
      sellerGstin: sellerGstin,

      // Buyer
      buyerName: buyerName,
      buyerAddress: buyerAddress,
      buyerGstin: buyerGstin,
      placeOfSupply: placeOfSupply,

      // Item
      description: description,
      hsnCode: hsnCode,
      quantity: quantity,
      unitPrice: unitPrice,
      discount: discount,

      // Taxes
      cgstPercent: cgstPercent,
      sgstPercent: sgstPercent,
      igstPercent: igstPercent,
      cgstAmount: cgstAmount,
      sgstAmount: sgstAmount,
      igstAmount: igstAmount,

      totalAmount: totalAmount,
    );
  }

  /// 🔥 Reset / Clear invoice
  void resetInvoice() {
    state = null;
    _invoiceCounter = 1; // restart numbering if needed
  }
}

/// Data model for GST Invoice
class GstInvoice {
  final int invoiceCounter;

  // Invoice
  final String invoiceNumber;
  final String invoiceDate;
  final String? orderNumber;
  final String? orderDate;

  // Seller
  final String sellerName;
  final String sellerAddress;
  final String sellerGstin;

  // Buyer
  final String buyerName;
  final String buyerAddress;
  final String buyerGstin;
  final String placeOfSupply;

  // Item
  final String description;
  final String hsnCode;
  final double quantity;
  final double unitPrice;
  final double discount;

  // Taxes
  final double cgstPercent;
  final double sgstPercent;
  final double igstPercent;
  final double cgstAmount;
  final double sgstAmount;
  final double igstAmount;

  // Final
  final double totalAmount;

  GstInvoice({
    required this.invoiceCounter,
    required this.invoiceNumber,
    required this.invoiceDate,
    this.orderNumber,
    this.orderDate,

    // Seller
    required this.sellerName,
    required this.sellerAddress,
    required this.sellerGstin,

    // Buyer
    required this.buyerName,
    required this.buyerAddress,
    required this.buyerGstin,
    required this.placeOfSupply,

    // Item
    required this.description,
    required this.hsnCode,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,

    // Taxes
    required this.cgstPercent,
    required this.sgstPercent,
    required this.igstPercent,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.igstAmount,

    // Final
    required this.totalAmount,
  });
}
