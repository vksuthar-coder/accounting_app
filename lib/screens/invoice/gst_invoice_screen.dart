import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/gst_invoice_provider.dart';
import '/utils/gst_invoice_pdf.dart';
import 'package:open_file/open_file.dart'; // <-- Added for opening PDF

class GstInvoiceScreen extends ConsumerStatefulWidget {
  const GstInvoiceScreen({super.key});

  @override
  ConsumerState<GstInvoiceScreen> createState() => _GstInvoiceScreenState();
}

class _GstInvoiceScreenState extends ConsumerState<GstInvoiceScreen> {
  // Controllers for Seller
  final sellerNameCtrl = TextEditingController();
  final sellerAddressCtrl = TextEditingController();
  final sellerGstinCtrl = TextEditingController();

  // Controllers for Buyer
  final buyerNameCtrl = TextEditingController();
  final buyerAddressCtrl = TextEditingController();
  final buyerGstinCtrl = TextEditingController();
  final placeOfSupplyCtrl = TextEditingController();

  // Controllers for Invoice
  final invoiceNumberCtrl = TextEditingController();
  final invoiceDateCtrl = TextEditingController();
  final orderNumberCtrl = TextEditingController();
  final orderDateCtrl = TextEditingController();

  // Controllers for Item
  final descriptionCtrl = TextEditingController();
  final hsnCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final unitPriceCtrl = TextEditingController();
  final discountCtrl = TextEditingController();

  // Controllers for Taxes
  final cgstCtrl = TextEditingController(text: "9"); // default %
  final sgstCtrl = TextEditingController(text: "9"); // default %
  final igstCtrl = TextEditingController(text: "0");

  @override
  void dispose() {
    sellerNameCtrl.dispose();
    sellerAddressCtrl.dispose();
    sellerGstinCtrl.dispose();
    buyerNameCtrl.dispose();
    buyerAddressCtrl.dispose();
    buyerGstinCtrl.dispose();
    placeOfSupplyCtrl.dispose();
    invoiceNumberCtrl.dispose();
    invoiceDateCtrl.dispose();
    orderNumberCtrl.dispose();
    orderDateCtrl.dispose();
    descriptionCtrl.dispose();
    hsnCtrl.dispose();
    qtyCtrl.dispose();
    unitPriceCtrl.dispose();
    discountCtrl.dispose();
    cgstCtrl.dispose();
    sgstCtrl.dispose();
    igstCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invoiceNotifier = ref.read(gstInvoiceProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("GST Invoice Generator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle("Seller Details"),
              textField("Seller Name", sellerNameCtrl),
              textField("Seller Address", sellerAddressCtrl),
              textField("Seller GSTIN", sellerGstinCtrl),

              const SizedBox(height: 20),
              sectionTitle("Buyer Details"),
              textField("Buyer Name", buyerNameCtrl),
              textField("Buyer Address", buyerAddressCtrl),
              textField("Buyer GSTIN (if any)", buyerGstinCtrl),
              textField("Place of Supply", placeOfSupplyCtrl),

              const SizedBox(height: 20),
              sectionTitle("Invoice Details"),
              textField("Invoice Number", invoiceNumberCtrl),
              textField("Invoice Date", invoiceDateCtrl),
              textField("Order Number", orderNumberCtrl),
              textField("Order Date", orderDateCtrl),

              const SizedBox(height: 20),
              sectionTitle("Item Details"),
              textField("Description", descriptionCtrl),
              textField("HSN Code", hsnCtrl),
              textField("Quantity", qtyCtrl, keyboard: TextInputType.number),
              textField("Unit Price", unitPriceCtrl, keyboard: TextInputType.number),
              textField("Discount", discountCtrl, keyboard: TextInputType.number),

              const SizedBox(height: 20),
              sectionTitle("Taxes (%)"),
              Row(
                children: [
                  Expanded(child: textField("CGST %", cgstCtrl, keyboard: TextInputType.number)),
                  const SizedBox(width: 10),
                  Expanded(child: textField("SGST %", sgstCtrl, keyboard: TextInputType.number)),
                  const SizedBox(width: 10),
                  Expanded(child: textField("IGST %", igstCtrl, keyboard: TextInputType.number)),
                ],
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      // Step 1: Generate invoice state
                      invoiceNotifier.generateInvoice(
                        sellerName: sellerNameCtrl.text,
                        sellerAddress: sellerAddressCtrl.text,
                        sellerGstin: sellerGstinCtrl.text,
                        buyerName: buyerNameCtrl.text,
                        buyerAddress: buyerAddressCtrl.text,
                        buyerGstin: buyerGstinCtrl.text,
                        placeOfSupply: placeOfSupplyCtrl.text,
                        invoiceNumber: invoiceNumberCtrl.text,
                        invoiceDate: invoiceDateCtrl.text,
                        orderNumber: orderNumberCtrl.text,
                        orderDate: orderDateCtrl.text,
                        description: descriptionCtrl.text,
                        hsnCode: hsnCtrl.text,
                        quantity: double.tryParse(qtyCtrl.text) ?? 0,
                        unitPrice: double.tryParse(unitPriceCtrl.text) ?? 0,
                        discount: double.tryParse(discountCtrl.text) ?? 0,
                        cgstPercent: double.tryParse(cgstCtrl.text) ?? 0,
                        sgstPercent: double.tryParse(sgstCtrl.text) ?? 0,
                        igstPercent: double.tryParse(igstCtrl.text) ?? 0,
                      );

                      final invoice = ref.read(gstInvoiceProvider);
                      if (invoice != null) {
                        // Step 2: Generate PDF
                        final file = await GstInvoicePdf.generatePdf(invoice);

                        // Step 3: Show path
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("PDF saved at: ${file.path}")),
                        );

                        // Step 4: Open PDF directly
                        await OpenFile.open(file.path);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  },
                  child: const Text("Generate & Open GST Invoice PDF"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget textField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
