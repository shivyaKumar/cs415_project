import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'RemoveStaff.dart';

const Color headerTeal = Color(0xFF008080);

class SASManage extends StatefulWidget {
  const SASManage({super.key});

  @override
  _SASManageState createState() => _SASManageState();
}

class _SASManageState extends State<SASManage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _fieldController = TextEditingController();
  String? _selectedQualification;
  String? _selectedEmploymentType;

  final List<String> _qualifications = ['Certificate', 'Diploma', 'Degree'];
  final List<String> _employmentTypes = ['Full-time', 'Part-time'];
  bool isManagerActive = true;

  void _toggleActiveCard(bool isManager) {
    setState(() {
      isManagerActive = isManager;
      _clearFields(); // Clear fields when switching
    });
  }

  void _clearFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _fieldController.clear();
    _selectedQualification = null;
    _selectedEmploymentType = null;
  }

  String _generateID(bool isManager) {
    int uniqueNumber = Random().nextInt(9999999);
    String prefix = isManager ? 'SA' : 'SS';
    return '$prefix${uniqueNumber.toString().padLeft(7, '0')}';
  }

  String _generateEmail(String id, bool isManager) {
    String domain = isManager ? 'manager.usp.ac.fj' : 'staff.usp.ac.fj';
    return '$id@$domain';
  }

  String _generatePassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(8, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  void _addUser() {
    String id = _generateID(isManagerActive);
    String email = _generateEmail(id, isManagerActive);
    String password = _generatePassword();

    _showUserDialog(id, email, password);
  }

  void _showUserDialog(String id, String email, String password) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('User Added'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: $id'),
              Text('Email: $email'),
              Text('Password: $password'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double textFieldWidth = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            color: Colors.white,
          ),
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
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: const Center(
                  child: Text(
                    'Manage Staff',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSelectionCard(
                    title: "Managers",
                    isSelected: isManagerActive,
                    onTap: () {
                      setState(() {
                        isManagerActive = true;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildSelectionCard(
                    title: "Staffs",
                    isSelected: !isManagerActive,
                    onTap: () {
                      setState(() {
                        isManagerActive = false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Navigate to RemoveStaffPage when clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RemoveStaffPage()),
                  );
                },
                child: const Text(
                  'View Staffs',
                  style: TextStyle(
                    color: headerTeal,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildForm(textFieldWidth),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildFooter(),
    );
  }

  Widget _buildSelectionCard(
      {required String title, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.teal : Colors.transparent,
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildForm(double textFieldWidth) {
    double cardWidth = 400; // Adjust this value to the desired card width

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: cardWidth, // Set the card width
          child: Column(
            children: [
              _buildTextField(_firstNameController, 'First Name', textFieldWidth),
              const SizedBox(height: 10),
              _buildTextField(_lastNameController, 'Last Name', textFieldWidth),
              const SizedBox(height: 10),
              if (isManagerActive)
                _buildDropdown(_qualifications, _selectedQualification, 'Qualification', (value) {
                  setState(() => _selectedQualification = value);
                }, textFieldWidth),
              if (isManagerActive) ...[
                const SizedBox(height: 10),
                _buildTextField(_fieldController, 'Field of Qualification', textFieldWidth),
              ],
              if (!isManagerActive)
                _buildDropdown(_employmentTypes, _selectedEmploymentType, 'Employment Type', (value) {
                  setState(() => _selectedEmploymentType = value);
                }, textFieldWidth),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _addUser,
                    child: Text(isManagerActive ? 'Add Manager' : 'Add Staff'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _clearFields,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextField(TextEditingController controller, String label, double width) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String? selectedValue, String label,
      void Function(String?) onChanged, double width) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  Widget _buildFooter({double height = 80}) {
    return SizedBox(
      height: height,
      child: Container(
        width: double.infinity,
        color: headerTeal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left column
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
            // Center column (SVG logo)
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/usp_logo.svg',
                  height: 40, // Adjust the logo size as needed
                ),
              ),
            ),
            // Right column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Developed by USP CSIT Department',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Powered by Flutter',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openLink(String url) {
    print('Open link: $url'); // Placeholder for actual URL opening logic
  }
}
