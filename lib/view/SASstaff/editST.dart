import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/SASStaff/editST_viewmodel.dart';
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';

class EditStudentPage extends StatelessWidget {
  const EditStudentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => EditStudentViewModel()..fetchStudents(),
      child: Scaffold(
        appBar: const CustomHeader(),
        body: Consumer<EditStudentViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Student Management",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : viewModel.students.isEmpty
                            ? const Center(child: Text("No students found"))
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text("ID")),
                                    DataColumn(label: Text("First Name")),
                                    DataColumn(label: Text("Middle Name")),
                                    DataColumn(label: Text("Last Name")),
                                    DataColumn(label: Text("Address")),
                                    DataColumn(label: Text("Contact")),
                                    DataColumn(label: Text("Date of Birth")),
                                    DataColumn(label: Text("Gender")),
                                    DataColumn(label: Text("Citizenship")),
                                    DataColumn(label: Text("Subprogram")),
                                    DataColumn(label: Text("Program")),
                                    DataColumn(label: Text("Student Level")),
                                    DataColumn(label: Text("Campus")),
                                    DataColumn(label: Text("Actions")),
                                  ],
                                  rows: viewModel.students.map((student) {
                                    return DataRow(cells: [
                                      DataCell(Text(student['id'] ?? '')),
                                      DataCell(Text(student['firstName'] ?? '')),
                                      DataCell(Text(student['middleName'] ?? '')),
                                      DataCell(Text(student['lastName'] ?? '')),
                                      DataCell(Text(student['address'] ?? '')),
                                      DataCell(Text(student['contact'] ?? '')),
                                      DataCell(Text(student['dateOfBirth'] ?? '')),
                                      DataCell(Text(student['gender'] ?? '')),
                                      DataCell(Text(student['citizenship'] ?? '')),
                                      DataCell(Text(student['subprogram'] ?? '')),
                                      DataCell(Text(student['program'] ?? '')),
                                      DataCell(Text(student['studentLevel'] ?? '')),
                                      DataCell(Text(student['campus'] ?? '')),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text("Confirm Deletion"),
                                                content: const Text("Are you sure you want to delete this student?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(true),
                                                    child: const Text("Delete"),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true) {
                                              await viewModel.deleteStudent(student['id']);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Student deleted successfully")),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: CustomFooter(screenWidth: screenWidth),
      ),
    );
  }
}