import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import '/providers/gst_invoice_provider.dart';
import 'package:flutter/services.dart';

class GstInvoicePdf {
  static Future<File> generatePdf(GstInvoice invoice) async {
    final pdf = pw.Document();

    // 🔹 Load Roboto font from assets
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    final boldFontData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    final ttfBold = pw.Font.ttf(boldFontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 🔹 Header
              pw.Text(
                "TAX INVOICE",
                style: pw.TextStyle(fontSize: 22, font: ttfBold),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Invoice #: ${invoice.invoiceNumber}", style: pw.TextStyle(font: ttf)),
                  pw.Text("Date: ${invoice.invoiceDate}", style: pw.TextStyle(font: ttf)),
                ],
              ),
              if (invoice.orderNumber != null)
                pw.Text("Order #: ${invoice.orderNumber}", style: pw.TextStyle(font: ttf)),
              if (invoice.orderDate != null)
                pw.Text("Order Date: ${invoice.orderDate}", style: pw.TextStyle(font: ttf)),
              pw.Divider(),

              // 🔹 Seller & Buyer
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Seller Details:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfBold)),
                        pw.Text(invoice.sellerName, style: pw.TextStyle(font: ttf)),
                        pw.Text(invoice.sellerAddress, style: pw.TextStyle(font: ttf)),
                        pw.Text("GSTIN: ${invoice.sellerGstin}", style: pw.TextStyle(font: ttf)),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Buyer Details:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfBold)),
                        pw.Text(invoice.buyerName, style: pw.TextStyle(font: ttf)),
                        pw.Text(invoice.buyerAddress, style: pw.TextStyle(font: ttf)),
                        if (invoice.buyerGstin.isNotEmpty)
                          pw.Text("GSTIN: ${invoice.buyerGstin}", style: pw.TextStyle(font: ttf)),
                        pw.Text("Place of Supply: ${invoice.placeOfSupply}", style: pw.TextStyle(font: ttf)),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // 🔹 Item Table
              pw.Table.fromTextArray(
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, font: ttfBold),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.black),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: const pw.EdgeInsets.all(5),
                cellStyle: pw.TextStyle(font: ttf),
                headers: [
                  "Description",
                  "HSN",
                  "Qty",
                  "Unit Price",
                  "Discount",
                  "Amount"
                ],
                data: [
                  [
                    invoice.description,
                    invoice.hsnCode,
                    invoice.quantity.toString(),
                    "₹${invoice.unitPrice.toStringAsFixed(2)}",
                    "₹${invoice.discount.toStringAsFixed(2)}",
                    "₹${((invoice.unitPrice * invoice.quantity) - invoice.discount).toStringAsFixed(2)}",
                  ],
                ],
              ),
              pw.SizedBox(height: 15),

              // 🔹 Tax Details
              pw.Text("Taxes:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfBold)),
              pw.Text("CGST (${invoice.cgstPercent}%): ₹${invoice.cgstAmount.toStringAsFixed(2)}", style: pw.TextStyle(font: ttf)),
              pw.Text("SGST (${invoice.sgstPercent}%): ₹${invoice.sgstAmount.toStringAsFixed(2)}", style: pw.TextStyle(font: ttf)),
              pw.Text("IGST (${invoice.igstPercent}%): ₹${invoice.igstAmount.toStringAsFixed(2)}", style: pw.TextStyle(font: ttf)),

              pw.SizedBox(height: 15),

              // 🔹 Total
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Grand Total: ₹${invoice.totalAmount.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: ttfBold),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save to file
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/invoice_${invoice.invoiceCounter}.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
