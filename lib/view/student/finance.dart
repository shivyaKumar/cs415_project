// Required Flutter and Provider packages for UI and state management
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModel handles business logic and data fetching (SOLID: SRP, OOP: Separation of Concerns)
import '../../viewmodels/finance_viewmodel.dart';

// Data models that represent individual entities (OOP: Encapsulation)
import '../../models/invoice_model.dart';
import '../../models/hold_model.dart';
import '../../models/payment_model.dart';
import '../../models/refund_model.dart';

// Custom reusable widgets for header and footer 
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';

// Service class responsible for generating PDF files (SOLID: SRP)
import '../../services/pdf_service.dart';

/// Stateful widget for the Finance Page which manages the dynamic state of the UI,
/// including fetching data via the FinancePageViewModel and handling UI expansion states.
class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

/// State class for FinancePage that holds UI state such as expanded/collapsed sections.
class _FinancePageState extends State<FinancePage> {
  // Custom color used for the navigation bar title background
  final Color navbarBlue = const Color.fromARGB(255, 8, 45, 87);

  // Boolean flags to control visibility of each finance section (Invoice, Payments, Refunds, Holds)
  bool showInvoiceDetails = false;
  bool showPaymentsCredits = false;
  bool showRefunds = false;
  bool showHolds = false;

  /// initState is called when this widget is inserted into the widget tree.
  /// Here we initialize our data by fetching invoices, holds, payments, and refunds using the view model.
  @override
  void initState() {
    super.initState();
    // Retrieve the ViewModel instance using Provider (Dependency Inversion)
    final viewModel = Provider.of<FinancePageViewModel>(context, listen: false);
    // Load all financial data on widget initialization
    viewModel.loadInvoices();
    viewModel.loadHolds();
    viewModel.loadPayments();
    viewModel.loadRefunds();
  }

  /// Build method returns the UI of the FinancePage.
  /// It uses various widgets like Scaffold, AppBar, LayoutBuilder, and SingleChildScrollView for responsiveness.
  @override
  Widget build(BuildContext context) {
    // Retrieve the ViewModel with listen=true so the UI updates when the data changes.
    final viewModel = Provider.of<FinancePageViewModel>(context);

    // Get screen width to adjust layout responsively.
    final screenWidth = MediaQuery.of(context).size.width;

    // Main page structure using Scaffold which contains the header, body, and footer.
    return Scaffold(
      appBar: const CustomHeader(), // Reusable custom header widget

      // The body contains a responsive layout that adjusts based on the screen size.
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Expanded widget to allow content to take available space.
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1040), // Centered card layout constraint
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            elevation: 4,
                            margin: const EdgeInsets.all(5.0),
                            child: Container(
                              color: const Color(0xFFF6F0FB),
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Section title bar with a custom background color
                                  Container(
                                    color: navbarBlue,
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Finance Menu',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),

                                  // Section: Invoice - builds a collapsible invoice section
                                  _buildFinanceSection(
                                    title: "Invoice",
                                    showContent: showInvoiceDetails,
                                    onTap: () => setState(() => showInvoiceDetails = !showInvoiceDetails),
                                    child: viewModel.invoices.isEmpty
                                        ? const Text("No invoice data available.")
                                        : _responsiveLayout(
                                            screenWidth,
                                            _buildInvoiceTable(viewModel.invoices),
                                            _buildInvoiceCards(viewModel.invoices),
                                          ),
                                  ),

                                  // Section: Payments/Credits - builds a collapsible payments/credits section
                                  _buildFinanceSection(
                                    title: "Payments/Credits",
                                    showContent: showPaymentsCredits,
                                    onTap: () => setState(() => showPaymentsCredits = !showPaymentsCredits),
                                    child: viewModel.payments.isEmpty
                                        ? const Text("You have no payments or credits.")
                                        : _responsiveLayout(
                                            screenWidth,
                                            _buildPaymentsTable(viewModel.payments),
                                            _buildPaymentsCards(viewModel.payments),
                                          ),
                                  ),

                                  // Section: Refunds - builds a collapsible refunds section
                                  _buildFinanceSection(
                                    title: "Refunds",
                                    showContent: showRefunds,
                                    onTap: () => setState(() => showRefunds = !showRefunds),
                                    child: viewModel.refunds.isEmpty
                                        ? const Text("You have no refunds.")
                                        : _responsiveLayout(
                                            screenWidth,
                                            _buildRefundsTable(viewModel.refunds),
                                            _buildRefundsCards(viewModel.refunds),
                                          ),
                                  ),

                                  // Section: Holds - builds a collapsible holds section
                                  _buildFinanceSection(
                                    title: "Holds",
                                    showContent: showHolds,
                                    onTap: () => setState(() => showHolds = !showHolds),
                                    child: viewModel.holds.isEmpty
                                        ? const Text("You have no holds.")
                                        : _responsiveLayout(
                                            screenWidth,
                                            _buildHoldsTable(viewModel.holds),
                                            _buildHoldsCards(viewModel.holds),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Reusable custom footer widget, passing the screen width for responsive design.
                    CustomFooter(screenWidth: screenWidth),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Helper method to build a collapsible finance section.
  /// Accepts a title, a flag to indicate if content should be shown, a callback for toggling the state,
  /// and the child widget that represents the content.
  Widget _buildFinanceSection({
    required String title,
    required bool showContent,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading with expand/collapse functionality using InkWell for tap detection.
        Material(
          color: Colors.blue.shade200,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // Underline text if the section is expanded
                  decoration: showContent ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
        // Conditional display of the section content if the section is expanded.
        if (showContent)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        const SizedBox(height: 10),
      ],
    );
  }

  /// Determines whether to display a table layout or a card layout based on the screen width.
  /// Large screens will see a table while mobile devices will see cards.
  Widget _responsiveLayout(double screenWidth, Widget table, Widget cards) {
    return screenWidth >= 600 ? table : cards;
  }

  /// Helper widget to display a labeled row for card views.
  /// This is used in card layouts to show data in a readable format.
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // -----------------------
  // Table Builders (Desktop)
  // -----------------------

  /// Builds a DataTable for invoice data.
  /// Each row includes invoice details and a button to generate a PDF.
  Widget _buildInvoiceTable(List<Invoice> data) => _buildDataTable(
    columns: const ["Term", "Invoice No.", "Invoice Date", "Amount Due", "Invoice"],
    rows: data.map((i) => [
      i.term,
      i.invoiceNo,
      i.invoiceDate,
      i.amountDue,
      ElevatedButton(
        onPressed: () => PDFService.generateInvoicePDF(i), // Encapsulated behavior via service
        child: const Text("Generate Invoice"),
      )
    ]).toList(),
  );

  /// Builds a DataTable for payments/credits data.
  Widget _buildPaymentsTable(List<Payment> data) => _buildDataTable(
    columns: const ["Amount", "Date", "Method"],
    rows: data.map((p) => [p.amount, p.date, p.method]).toList(),
  );

  /// Builds a DataTable for refunds data.
  Widget _buildRefundsTable(List<Refund> data) => _buildDataTable(
    columns: const ["Amount", "Date", "Reason"],
    rows: data.map((r) => [r.amount, r.date, r.reason]).toList(),
  );

  /// Builds a DataTable for holds data.
  Widget _buildHoldsTable(List<Hold> data) => _buildDataTable(
    columns: const ["Reason", "Date", "Status"],
    rows: data.map((h) => [h.reason, h.date, h.status]).toList(),
  );

  /// Generic method for creating a DataTable.
  /// It receives a list of column names and rows, then maps them to DataColumn and DataRow widgets.
  Widget _buildDataTable({
    required List<String> columns,
    required List<List<dynamic>> rows,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1000,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(navbarBlue),
          headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          columns: columns.map((c) => DataColumn(label: Text(c))).toList(),
          rows: rows.map((r) => DataRow(
            cells: r.map((c) => DataCell(c is Widget ? c : Text(c.toString()))).toList(),
          )).toList(),
        ),
      ),
    );
  }

  // -------------------------
  // Card Builders (Mobile UI)
  // -------------------------

  /// Builds a list of cards for displaying invoice data in mobile view.
  /// Each card shows detailed invoice information and a button to generate the invoice PDF.
  Widget _buildInvoiceCards(List<Invoice> data) => _buildCardList(data.map((i) => [
    _infoRow("Term", i.term),
    _infoRow("Invoice No.", i.invoiceNo),
    _infoRow("Invoice Date", i.invoiceDate),
    _infoRow("Amount Due", i.amountDue),
    Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () => PDFService.generateInvoicePDF(i),
        child: const Text("Generate Invoice"),
      ),
    )
  ]));

  /// Builds a list of cards for displaying payments/credits data in mobile view.
  Widget _buildPaymentsCards(List<Payment> data) => _buildCardList(data.map((p) => [
    _infoRow("Amount", p.amount),
    _infoRow("Date", p.date),
    _infoRow("Method", p.method),
  ]));

  /// Builds a list of cards for displaying refunds data in mobile view.
  Widget _buildRefundsCards(List<Refund> data) => _buildCardList(data.map((r) => [
    _infoRow("Amount", r.amount),
    _infoRow("Date", r.date),
    _infoRow("Reason", r.reason),
  ]));

  /// Builds a list of cards for displaying holds data in mobile view.
  Widget _buildHoldsCards(List<Hold> data) => _buildCardList(data.map((h) => [
    _infoRow("Reason", h.reason),
    _infoRow("Date", h.date),
    _infoRow("Status", h.status),
  ]));

  /// Generic card builder that creates a column of card widgets.
  /// Each card is built from a list of widgets (the content) and styled with padding and borders.
  Widget _buildCardList(Iterable<List<Widget>> contents) {
    return Column(
      children: contents.map((widgets) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        );
      }).toList(),
    );
  }
}
