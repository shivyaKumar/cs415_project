import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/SASStaff/registerStudent-viewmodel.dart';
import 'widgets/custom_header.dart';
import 'widgets/custom_footer.dart';

class RegisterStudentPage extends StatelessWidget {
  const RegisterStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterStudentViewModel>(context); // Access the ViewModel

    return Scaffold(
      appBar: const CustomHeader(), // Use the custom header
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey, // Use the form key from the ViewModel
          child: ListView(
            children: [
              TextFormField(
                controller: viewModel.firstNameController,
                decoration: const InputDecoration(labelText: "First Name"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: viewModel.middleNameController,
                decoration: const InputDecoration(labelText: "Middle Name (Optional)"),
              ),
              TextFormField(
                controller: viewModel.lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              ListTile(
                title: Text(viewModel.selectedDate == null
                    ? "Select Date of Birth"
                    : "Date of Birth: ${viewModel.selectedDate.toString().split(" ")[0]}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => viewModel.pickDate(context), // Use the date picker from the ViewModel
              ),
              TextFormField(
                controller: viewModel.genderController,
                decoration: const InputDecoration(labelText: "Gender"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: viewModel.citizenshipController,
                decoration: const InputDecoration(labelText: "Citizenship"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Program"),
                value: viewModel.selectedProgram,
                items: viewModel.programs.map((String program) {
                  return DropdownMenuItem(value: program, child: Text(program));
                }).toList(),
                onChanged: (value) {
                  viewModel.selectedProgram = value;
                  viewModel.notifyListeners(); // Notify listeners when the program changes
                },
                validator: (value) => value == null ? "Required" : null,
              ),
              TextFormField(
                controller: viewModel.studentLevelController,
                decoration: const InputDecoration(labelText: "Student Level"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Campus"),
                value: viewModel.selectedCampus,
                items: viewModel.campuses.map((String campus) {
                  return DropdownMenuItem(value: campus, child: Text(campus));
                }).toList(),
                onChanged: (value) {
                  viewModel.selectedCampus = value;
                  viewModel.notifyListeners(); // Notify listeners when the campus changes
                },
                validator: (value) => value == null ? "Required" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => viewModel.submitForm(context), // Use the submit logic from the ViewModel
                child: const Text("Register"),
              ),
              const SizedBox(height: 20),
              CustomFooter(screenWidth: MediaQuery.of(context).size.width), // Use the custom footer
            ],
          ),
        ),
      ),
    );
  }
}