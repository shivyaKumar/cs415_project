import 'package:flutter/material.dart';
import '../../xml_loader.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';

class RegisterStudentViewModel extends ChangeNotifier {
  // Form Key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController citizenshipController = TextEditingController();
  final TextEditingController studentLevelController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  // Selected values
  DateTime? selectedDate;
  String? selectedProgram;
  String? selectedSubprogram;
  String? selectedCampus;

  // Dropdown data
  List<String> programs = []; // Programs will be loaded dynamically
  List<String> subprograms = []; // Subprograms will be loaded dynamically
  List<String> campuses = []; // Campuses will be fetched dynamically

  // Load Programs from XML
  Future<void> loadPrograms() async {
    try {
      // Fetch subprogrammes first (required for programs)
      final subProgramData = await XmlUploader.parseSubProgrammes();
      subprograms = subProgramData.values.map((subprogram) => subprogram['name'] as String).toList();

      // Fetch programs using subprogrammes
      final programData = await XmlUploader.parsePrograms(subProgramData);
      programs = programData.values.map((program) => program['name'] as String).toList();

      debugPrint("Programs loaded: $programs");
      debugPrint("Subprograms loaded: $subprograms");
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading programs or subprograms: $e");
    }
  }

  // Load Campuses from Firebase
  Future<void> loadCampuses() async {
    try {
      campuses = await XmlUploader.fetchCampuses(); // Fetch campuses from Firebase
      debugPrint("Campuses loaded: $campuses");
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading campuses: $e");
    }
  }

  // Date Picker
  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate = picked;
      dateOfBirthController.text = picked.toLocal().toString().split(' ')[0]; // Update the controller
      notifyListeners();
    }
  }

  // Submit Form
  void submitForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (selectedProgram == null || selectedSubprogram == null || selectedCampus == null || selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields")),
        );
        return;
      }

      final database = FirebaseDatabase.instance.ref("students");

      try {
        // Check if the student already exists
        final snapshot = await database.get();
        if (snapshot.exists) {
          final students = snapshot.value as Map<dynamic, dynamic>;
          for (var student in students.values) {
            if (student['firstName'] == firstNameController.text &&
                student['lastName'] == lastNameController.text &&
                student['contact'] == contactController.text) {
              // Student already exists
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Student already exists - ID: ${student['id']}")),
              );
              return;
            }
          }
        }

        // Generate the next student ID
        String studentId = _generateNextStudentId(snapshot);

        // Generate a random password
        final password = _generatePassword();

        // Save the student data in the database
        final newStudent = {
          'id': studentId,
          'firstName': firstNameController.text,
          'middleName': middleNameController.text,
          'lastName': lastNameController.text,
          'address': addressController.text,
          'contact': contactController.text,
          'dateOfBirth': selectedDate.toString().split(" ")[0],
          'gender': genderController.text,
          'citizenship': citizenshipController.text,
          'subprogram': selectedSubprogram,
          'program': selectedProgram,
          'studentLevel': studentLevelController.text,
          'campus': selectedCampus,
          'password': password,
        };
        await database.child(studentId).set(newStudent);

        // Show a dialog box with the student ID and password
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Student Registered Successfully"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Student ID: $studentId"),
                  Text("Password: $password"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );

        // Clear the form after submission
        clearForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error registering student: $e")),
        );
      }
    }
  }

  // Helper method to generate the next student ID
  String _generateNextStudentId(DataSnapshot snapshot) {
    if (!snapshot.exists) {
      return "S0000001"; // First student ID if no students exist
    }

    final students = snapshot.value as Map<dynamic, dynamic>;
    final ids = students.keys.map((key) => key.toString()).toList();

    // Sort IDs to find the last one
    ids.sort();
    final lastId = ids.last;

    // Extract the numeric part and increment it
    try {
      final numericPart = int.parse(RegExp(r'\d+$').stringMatch(lastId) ?? '0'); // Match numeric part at the end
      final nextNumericPart = numericPart + 1;

      // Format the new ID
      return "S${nextNumericPart.toString().padLeft(7, '0')}";
    } catch (e) {
      throw FormatException("Invalid student ID format: $lastId");
    }
  }

  // Helper method to generate an 8-character alphanumeric password
  String _generatePassword() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // Clear Form
  void clearForm() {
    firstNameController.clear();
    middleNameController.clear();
    lastNameController.clear();
    addressController.clear();
    contactController.clear();
    genderController.clear();
    citizenshipController.clear();
    studentLevelController.clear();
    dateOfBirthController.clear();
    selectedDate = null;
    selectedProgram = null;
    selectedSubprogram = null;
    selectedCampus = null;
    notifyListeners();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    contactController.dispose();
    genderController.dispose();
    citizenshipController.dispose();
    studentLevelController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }
}