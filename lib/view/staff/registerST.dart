import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xml/xml.dart' as xml;

class RegisterStudentPage extends StatefulWidget {
  const RegisterStudentPage({super.key});

  @override
  _RegisterStudentPageState createState() => _RegisterStudentPageState();
}

class _RegisterStudentPageState extends State<RegisterStudentPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController citizenshipController = TextEditingController();
  TextEditingController studentLevelController = TextEditingController();

  // Selected values
  DateTime? selectedDate;
  String? selectedProgram;
  String? selectedCampus;

  // Dropdown data
  List<String> programs = [];
  List<String> campuses = [];

  @override
  void initState() {
    super.initState();
    loadPrograms();
    loadCampuses();
  }

  // Load Programs from XML
  Future<void> loadPrograms() async {
    String data = await rootBundle.loadString('assets/STEMP/programs.xml');
    final document = xml.XmlDocument.parse(data);
    setState(() {
      programs = document.findAllElements('program').map((element) {
        return element.getAttribute('programName') ?? "Unknown";
      }).toList();
    });
  }

  // Load Campuses from XML
  Future<void> loadCampuses() async {
    String data = await rootBundle.loadString('assets/campuses.xml');
    final document = xml.XmlDocument.parse(data);
    setState(() {
      campuses = document.findAllElements('campus').map((element) {
        return element.getAttribute('campusName') ?? "Unknown";
      }).toList();
    });
  }

  // Date Picker
  Future<void> _pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Submit Form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (selectedProgram == null || selectedCampus == null || selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill all required fields")),
        );
        return;
      }
      // Perform registration action
      print("Registering Student:");
      print("First Name: ${firstNameController.text}");
      print("Middle Name: ${middleNameController.text}");
      print("Last Name: ${lastNameController.text}");
      print("Date of Birth: ${selectedDate.toString().split(" ")[0]}");
      print("Gender: ${genderController.text}");
      print("Citizenship: ${citizenshipController.text}");
      print("Program: $selectedProgram");
      print("Student Level: ${studentLevelController.text}");
      print("Campus: $selectedCampus");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student Registered Successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: AppBar(
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/header.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: "First Name"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: middleNameController,
                decoration: InputDecoration(labelText: "Middle Name (Optional)"),
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: "Last Name"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              ListTile(
                title: Text(selectedDate == null
                    ? "Select Date of Birth"
                    : "Date of Birth: ${selectedDate.toString().split(" ")[0]}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _pickDate(context),
              ),
              TextFormField(
                controller: genderController,
                decoration: InputDecoration(labelText: "Gender"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: citizenshipController,
                decoration: InputDecoration(labelText: "Citizenship"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Program"),
                value: selectedProgram,
                items: programs.map((String program) {
                  return DropdownMenuItem(value: program, child: Text(program));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProgram = value;
                  });
                },
                validator: (value) => value == null ? "Required" : null,
              ),
              TextFormField(
                controller: studentLevelController,
                decoration: InputDecoration(labelText: "Student Level"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Campus"),
                value: selectedCampus,
                items: campuses.map((String campus) {
                  return DropdownMenuItem(value: campus, child: Text(campus));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCampus = value;
                  });
                },
                validator: (value) => value == null ? "Required" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Register"),
              ),
              const SizedBox(height: 20),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildFooter({double height = 80}) {
  return SizedBox(
    height: height,
    child: Container(
      width: double.infinity,
      color: Colors.teal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => _openLink('https://www.example.com/copyright'),
                      child: const Text(
                        'Copyright',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('|', style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _openLink('https://www.example.com/contact'),
                      child: const Text(
                        'Contact Us',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '© Copyright 1968 - 2025. All Rights Reserved.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/usp_logo.svg',
                width: 133,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text('The University of the South Pacific', style: TextStyle(color: Colors.white)),
                Text('Laucala Campus, Suva, Fiji', style: TextStyle(color: Colors.white)),
                Text('Tel: +679 323 1000', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void _openLink(String url) {
  print('Opening link: $url');
}