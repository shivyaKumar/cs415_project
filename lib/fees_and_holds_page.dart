import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'firebase_service.dart';
import 'models/student_model.dart';
import 'models/student_course_fee_model.dart';
import 'models/hold_model.dart';

class FeesAndHoldsPage extends StatefulWidget {
  final String studentId;

  const FeesAndHoldsPage({Key? key, required this.studentId}) : super(key: key);

  @override
  _FeesAndHoldsPageState createState() => _FeesAndHoldsPageState();
}

class _FeesAndHoldsPageState extends State<FeesAndHoldsPage> {
  final _amountController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _reasonController = TextEditingController();
  final _statusController = TextEditingController();

  StudentModel? student;
  List<StudentCourseFee> fees = [];
  List<Hold> holds = [];

  // Toggle visibility of fee and hold sections
  bool showAddFeeHold = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final s = await FirebaseService.fetchStudentInfo(widget.studentId);
    final f = await FirebaseService.fetchCourseFees(widget.studentId);
    final h = await FirebaseService.fetchHolds(widget.studentId);
    setState(() {
      student = s;
      fees = f;
      holds = h;
    });
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Student Invoice', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 20),
          if (student != null) ...[
            pw.Text('Student ID: ${student!.id}', style: pw.TextStyle(fontSize: 12)),
            pw.Text('Name: ${student!.name}', style: pw.TextStyle(fontSize: 12)),
            pw.Text('Program: ${student!.program}', style: pw.TextStyle(fontSize: 12)),
            pw.Text('Subprograms: ${student!.subprograms.join(', ')}', style: pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 20),
          ],
          pw.Text('Fees', style: pw.TextStyle(fontSize: 18)),
          ...fees.map((fee) => pw.Text('Amount: \$${fee.amount}, Due: ${fee.dueDate}', style: pw.TextStyle(fontSize: 12))),
          pw.SizedBox(height: 20),
          pw.Text('Holds', style: pw.TextStyle(fontSize: 18)),
          ...holds.map((hold) => pw.Text('Reason: ${hold.reason}, Status: ${hold.status}', style: pw.TextStyle(fontSize: 12))),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fees and Holds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generatePDF,
          ),
        ],
      ),
      body: student == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Student ID: ${student!.id}'),
                  Text('Name: ${student!.firstName} ${student!.lastName}'),
                  Text('Program: ${student!.programName}'),
                  Text('Subprogram: ${student!.subprogram}'),
                  const Divider(),

                  // Display Course Fees
                  const Text('Course Fees:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...fees.map((fee) => ListTile(
                        title: Text('Amount: \$${fee.amount}'),
                        subtitle: Text('Due Date: ${fee.dueDate}'),
                      )),

                  const Divider(),

                  // Display Holds
                  const Text('Holds:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...holds.map((hold) => ListTile(
                        title: Text('Reason: ${hold.reason}'),
                        subtitle: Text('Status: ${hold.status}'),
                      )),

                  const Divider(),

                  // Button to toggle the visibility of Add Fee and Hold sections
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showAddFeeHold = !showAddFeeHold;
                      });
                    },
                    child: Text(showAddFeeHold ? 'Hide Fee and Hold Sections' : 'Add Fee and Hold'),
                  ),

                  // Display Fee and Hold section only if `showAddFeeHold` is true
                  if (showAddFeeHold) ...[
                    const Text('Add Course Fee', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _dueDateController,
                      decoration: const InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
                    ),
                    const SizedBox(height: 10),

                    const Text('Add Hold', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _reasonController,
                      decoration: const InputDecoration(labelText: 'Hold Reason'),
                    ),
                    TextField(
                      controller: _statusController,
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        double amount = double.tryParse(_amountController.text) ?? 0.0;
                        String dueDate = _dueDateController.text;
                        String reason = _reasonController.text;
                        String status = _statusController.text;

                        await FirebaseService.pushCourseFees(widget.studentId, amount, dueDate);
                        await FirebaseService.pushHold(widget.studentId, reason, status);

                        _amountController.clear();
                        _dueDateController.clear();
                        _reasonController.clear();
                        _statusController.clear();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data Submitted Successfully')),
                        );

                        await _loadData(); // Refresh data
                      },
                      child: const Text('Submit'),
                    ),
                    const Divider(),
                  ],
                ],
              ),
            ),
    );
  }
}
