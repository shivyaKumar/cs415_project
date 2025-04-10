import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/SASStaff/registerStudent-viewmodel.dart';
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';

class RegisterStudentPage extends StatelessWidget {
  const RegisterStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterStudentViewModel>(context, listen: false);

    return Scaffold(
      appBar: const CustomHeader(),
      body: FutureBuilder(
        future: Future.wait([
          viewModel.loadPrograms(), // Load programs
          viewModel.loadCampuses(), // Load campuses
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data: ${snapshot.error}"));
          }

          return Center(
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        // First Name Text Field
                        TextFormField(
                          controller: viewModel.firstNameController,
                          decoration: const InputDecoration(labelText: "First Name"),
                          validator: (value) => value!.isEmpty ? "Required" : null,
                        ),

                        // Middle Name Text Field
                        TextFormField(
                          controller: viewModel.middleNameController,
                          decoration: const InputDecoration(labelText: "Middle Name"),
                        ),

                        // Last Name Text Field
                        TextFormField(
                          controller: viewModel.lastNameController,
                          decoration: const InputDecoration(labelText: "Last Name"),
                          validator: (value) => value!.isEmpty ? "Required" : null,
                        ),

                        // Address Text Field
                        TextFormField(
                          controller: viewModel.addressController,
                          decoration: const InputDecoration(labelText: "Address"),
                          validator: (value) => value!.isEmpty ? "Required" : null,
                        ),

                        // Contact Text Field
                        TextFormField(
                          controller: viewModel.contactController,
                          decoration: const InputDecoration(labelText: "Contact (e.g., 679-1234567)"),
                          validator: (value) {
                            final regex = RegExp(r'^679-\d{7}$');
                            if (value == null || value.isEmpty) {
                              return "Required";
                            } else if (!regex.hasMatch(value)) {
                              return "Invalid contact format";
                            }
                            return null;
                          },
                        ),

                        // Date of Birth Picker
                        TextFormField(
                          controller: viewModel.dateOfBirthController, // Use the dedicated controller
                          readOnly: true, // Prevent manual input
                          decoration: const InputDecoration(labelText: "Date of Birth"),
                          onTap: () => viewModel.pickDate(context), // Open the date picker
                          validator: (value) => value!.isEmpty ? "Required" : null,
                        ),

                        // Gender Text Field
                        TextFormField(
                          controller: viewModel.genderController,
                          decoration: const InputDecoration(labelText: "Gender"),
                          validator: (value) => value!.isEmpty ? "Required" : null,
                        ),

                        // Citizenship Text Field
                        TextFormField(
                          controller: viewModel.citizenshipController,
                          decoration: const InputDecoration(labelText: "Citizenship"),
                          validator: (value) => value!.isEmpty ? "Required" : null,
                        ),

                        // Student Level Text Field
                        TextFormField(
                          controller: viewModel.studentLevelController,
                          decoration: const InputDecoration(labelText: "Student Level"),
                          validator: (value) => value!.isEmpty ? "Required" : null,
                        ),

                        // Program Dropdown
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: "Program"),
                          value: viewModel.selectedProgram,
                          items: viewModel.programs.map((String program) {
                            return DropdownMenuItem(value: program, child: Text(program));
                          }).toList(),
                          onChanged: (value) {
                            viewModel.selectedProgram = value;
                            viewModel.notifyListeners();
                          },
                          validator: (value) => value == null ? "Required" : null,
                        ),

                        // Subprogram Dropdown
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: "Subprogram"),
                          value: viewModel.selectedSubprogram,
                          items: viewModel.subprograms.map((String subprogram) {
                            return DropdownMenuItem(value: subprogram, child: Text(subprogram));
                          }).toList(),
                          onChanged: (value) {
                            viewModel.selectedSubprogram = value;
                            viewModel.notifyListeners();
                          },
                          validator: (value) => value == null ? "Required" : null,
                        ),

                        // Campus Dropdown
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: "Campus"),
                          value: viewModel.selectedCampus,
                          items: viewModel.campuses.map((String campus) {
                            return DropdownMenuItem(value: campus, child: Text(campus));
                          }).toList(),
                          onChanged: (value) {
                            viewModel.selectedCampus = value;
                            viewModel.notifyListeners();
                          },
                          validator: (value) => value == null ? "Required" : null,
                        ),

                        const SizedBox(height: 20),

                        // Buttons Row: Register and Clear
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Register Button
                            ElevatedButton(
                              onPressed: () {
                                if (viewModel.formKey.currentState!.validate()) {
                                  viewModel.submitForm(context);
                                }
                              },
                              child: const Text("Register"),
                            ),
                            const SizedBox(width: 16), // Space between buttons

                            // Clear Button
                            ElevatedButton(
                              onPressed: () {
                                viewModel.clearForm();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // Set a different color for the Clear button
                              ),
                              child: const Text("Clear"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}