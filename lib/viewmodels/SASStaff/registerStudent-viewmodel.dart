import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart' as xml;

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

  // Selected values
  DateTime? selectedDate;
  String? selectedProgram;
  String? selectedCampus;

  // Dropdown data
  List<String> programs = [];
  List<String> campuses = [];

  // Load Programs from XML
  Future<void> loadPrograms() async {
    try {
      String stempData = await rootBundle.loadString('assets/STEMP/programs.xml');
      final stempDocument = xml.XmlDocument.parse(stempData);

      String solassData = await rootBundle.loadString('assets/SoLaSS/programs.xml');
      final solassDocument = xml.XmlDocument.parse(solassData);

      programs = [
        ...stempDocument.findAllElements('program').map((element) {
          return element.getAttribute('programName') ?? "Unknown";
        }),
        ...solassDocument.findAllElements('program').map((element) {
          return element.getAttribute('programName') ?? "Unknown";
        }),
      ];
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading programs: $e");
    }
  }

  // Load Campuses from XML
  Future<void> loadCampuses() async {
    try {
      String data = await rootBundle.loadString('assets/campuses.xml');
      final document = xml.XmlDocument.parse(data);

      campuses = document.findAllElements('campus').map((element) {
        return element.getAttribute('campusName') ?? "Unknown";
      }).toList();
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
      notifyListeners();
    }
  }

  // Submit Form
  void submitForm(BuildContext context) {
    if (formKey.currentState!.validate()) {
      if (selectedProgram == null || selectedCampus == null || selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields")),
        );
        return;
      }

      // Perform registration action
      debugPrint("Registering Student:");
      debugPrint("First Name: ${firstNameController.text}");
      debugPrint("Middle Name: ${middleNameController.text}");
      debugPrint("Last Name: ${lastNameController.text}");
      debugPrint("Date of Birth: ${selectedDate.toString().split(" ")[0]}");
      debugPrint("Gender: ${genderController.text}");
      debugPrint("Citizenship: ${citizenshipController.text}");
      debugPrint("Program: $selectedProgram");
      debugPrint("Student Level: ${studentLevelController.text}");
      debugPrint("Campus: $selectedCampus");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Student Registered Successfully!")),
      );

      // Clear form after submission
      clearForm();
    }
  }

  // Clear Form
  void clearForm() {
    firstNameController.clear();
    middleNameController.clear();
    lastNameController.clear();
    genderController.clear();
    citizenshipController.clear();
    studentLevelController.clear();
    selectedDate = null;
    selectedProgram = null;
    selectedCampus = null;
    notifyListeners();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    genderController.dispose();
    citizenshipController.dispose();
    studentLevelController.dispose();
    super.dispose();
  }
}