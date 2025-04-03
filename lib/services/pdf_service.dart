import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/invoice_model.dart';

class PDFService {
  static Future<void> generateInvoicePDF(Invoice invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('INVOICE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text('Term: ${invoice.term}'),
            pw.Text('Invoice No: ${invoice.invoiceNo}'),
            pw.Text('Invoice Date: ${invoice.invoiceDate}'),
            pw.Text('Amount Due: ${invoice.amountDue}'),
          ],
        ),
      ),
    );

    // Trigger print/save dialog
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
