import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class StudentRegistrationPage extends StatefulWidget {
  const StudentRegistrationPage({super.key});

  @override
  State<StudentRegistrationPage> createState() => _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController firstName = TextEditingController();
  final TextEditingController middleName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController programName = TextEditingController();
  final TextEditingController subprogram = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController citizenship = TextEditingController();
  final TextEditingController contact = TextEditingController();

  // Dropdown Options
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> programLevelOptions = [
    'Certificate',
    'Diploma',
    'Undergraduate',
    'Postgraduate',
    'Masters'
  ];
  final List<String> campusOptions = [
    'Laucala',
    'Lautoka',
    'Labasa',
    'Emalus',
    'Alafua',
    'Other'
  ];

  // Selected Values
  String? selectedGender;
  String? selectedProgramLevel;
  String? selectedCampus;

  @override
  void initState() {
    super.initState();
    selectedGender = genderOptions.first;
    selectedProgramLevel = programLevelOptions.first;
    selectedCampus = campusOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('USP Enrollment Form')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('First Name', firstName),
              _buildTextField('Middle Name', middleName),
              _buildTextField('Last Name', lastName),
              _buildTextField('Date of Birth', dob, hint: 'YYYY-MM-DD'),
              _buildDropdown('Gender', genderOptions, selectedGender!, (val) => setState(() => selectedGender = val)),
              _buildDropdown('Program Level', programLevelOptions, selectedProgramLevel!, (val) => setState(() => selectedProgramLevel = val)),
              _buildTextField('Program Name', programName),
              _buildTextField('Major/Minor (Subprogram)', subprogram),
              _buildDropdown('Campus', campusOptions, selectedCampus!, (val) => setState(() => selectedCampus = val)),
              _buildTextField('Address', address),
              _buildTextField('Citizenship', citizenship),
              _buildTextField('Contact', contact),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, hintText: hint),
        validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, void Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: (val) => onChanged(val!),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final uuid = const Uuid();
      final studentId = uuid.v4();

      final studentData = {
        'studentId': studentId,
        'firstName': firstName.text.trim(),
        'middleName': middleName.text.trim(),
        'lastName': lastName.text.trim(),
        'dob': dob.text.trim(),
        'gender': selectedGender,
        'programLevel': selectedProgramLevel,
        'programName': programName.text.trim(),
        'subprogram': subprogram.text.trim(),
        'campus': selectedCampus,
        'address': address.text.trim(),
        'citizenship': citizenship.text.trim(),
        'contact': contact.text.trim(),
        'createdAt': Timestamp.now(),
      };

      try {
        await FirebaseFirestore.instance.collection('students').doc(studentId).set(studentData);

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Registration Successful'),
            content: Text('Student ID: $studentId\nName: ${firstName.text} ${lastName.text}'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
            ],
          ),
        );

        _formKey.currentState!.reset();
        firstName.clear();
        middleName.clear();
        lastName.clear();
        dob.clear();
        programName.clear();
        subprogram.clear();
        address.clear();
        citizenship.clear();
        contact.clear();
        setState(() {
          selectedGender = genderOptions.first;
          selectedProgramLevel = programLevelOptions.first;
          selectedCampus = campusOptions.first;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
