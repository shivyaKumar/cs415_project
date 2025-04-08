import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import "widgets/custom_footer.dart";
import "widgets/custom_header.dart";

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const Color headerTeal = Color(0xFF009999);
  final int _selectedIndex = 0;

  final List<String> _labels = [
    'Personal Details',
    'Address',
    'Email & Phone',
    'Emergency Contact',
    'Passport & Visa',
  ];

  String? _chosenFileName;

  final Map<String, String> personalData = {
    'firstName': '',
    'middleName': '',
    'lastName': '',
    'dob': '',
    'gender': '',
    'citizenship': '',
    'program': '',
    'studentLevel': '',
    'studentCampus': '',
  };

  final Map<String, String> addressData = {
    'street': '',
    'city': '',
    'stateProvince': '',
    'country': '',
    'postalCode': '',
  };

  final Map<String, String> emailPhoneData = {
    'email': '',
    'phone': '',
  };

  final Map<String, String> emergencyData = {
    'firstName': '',
    'middleName': '',
    'lastName': '',
    'relationship': '',
    'contactPhone': '',
  };

  final Map<String, String> passportVisaData = {
    'passportNumber': '',
    'visaStatus': '',
    'expirationDate': '',
  };

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomHeader(), // Use the custom header
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildSectionContent(_selectedIndex),
                    ),
                  ),
                ),
              ),
            ),
            CustomFooter(screenWidth: screenWidth), // Use the custom footer
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContent(int index) {
    switch (index) {
      case 0:
        return _buildPersonalDetailsSection();
      case 1:
        return _buildAddressSection();
      case 2:
        return _buildEmailPhoneSection();
      case 3:
        return _buildEmergencyContactSection();
      case 4:
        return _buildPassportVisaSection();
      default:
        return _buildPersonalDetailsSection();
    }
  }

  Widget _buildPersonalDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhotoUploadSection(),
        const SizedBox(height: 16),
        const Text(
          'Personal Profile',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildLabelAndValue('First Name', personalData['firstName'] ?? ''),
        _buildLabelAndValue('Middle Name', personalData['middleName'] ?? ''),
        _buildLabelAndValue('Last Name', personalData['lastName'] ?? ''),
        _buildLabelAndValue('Date of Birth', personalData['dob'] ?? ''),
        _buildLabelAndValue('Gender', personalData['gender'] ?? ''),
        _buildLabelAndValue('Citizenship', personalData['citizenship'] ?? ''),
        _buildLabelAndValue('Program', personalData['program'] ?? ''),
        _buildLabelAndValue('Student Level', personalData['studentLevel'] ?? ''),
        _buildLabelAndValue('Student Campus', personalData['studentCampus'] ?? ''),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          color: const Color.fromARGB(255, 128, 35, 35),
          padding: const EdgeInsets.all(9.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Please Verify',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'If the information given above is incorrect, please contact the '
                'Student Administrative Services Office, providing the '
                'appropriate documentary evidence.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Passport Size Photo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'jpeg'],
                  allowMultiple: false,
                );
                if (result != null && result.files.isNotEmpty) {
                  setState(() {
                    _chosenFileName = result.files.single.name;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 145, 148, 148),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                textStyle: const TextStyle(fontSize: 14),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text('Choose File'),
            ),
            const SizedBox(width: 8),
            Text(_chosenFileName ?? 'No file chosen'),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Please ensure that the photo you upload is your true resemblance '
          'and is of a passport size. Only JPG files less than 5MB permitted.',
          style: TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            debugPrint('Save clicked for file: $_chosenFileName');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: headerTeal,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildLabelAndValue(String label, String value) {
    final displayValue = value.isEmpty ? 'N/A' : value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              child: Text(displayValue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildLabelAndValue('Street', addressData['street'] ?? ''),
        _buildLabelAndValue('City', addressData['city'] ?? ''),
        _buildLabelAndValue('State/Province', addressData['stateProvince'] ?? ''),
        _buildLabelAndValue('Country', addressData['country'] ?? ''),
        _buildLabelAndValue('Postal Code', addressData['postalCode'] ?? ''),
      ],
    );
  }

  Widget _buildEmailPhoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email & Phone',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildLabelAndValue('Email', emailPhoneData['email'] ?? ''),
        _buildLabelAndValue('Phone', emailPhoneData['phone'] ?? ''),
      ],
    );
  }

  Widget _buildEmergencyContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Emergency Contact',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildLabelAndValue('First Name', emergencyData['firstName'] ?? ''),
        _buildLabelAndValue('Middle Name', emergencyData['middleName'] ?? ''),
        _buildLabelAndValue('Last Name', emergencyData['lastName'] ?? ''),
        _buildLabelAndValue('Relationship', emergencyData['relationship'] ?? ''),
        _buildLabelAndValue('Contact Phone', emergencyData['contactPhone'] ?? ''),
      ],
    );
  }

  Widget _buildPassportVisaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Passport & Visa',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildLabelAndValue('Passport Number', passportVisaData['passportNumber'] ?? ''),
        _buildLabelAndValue('Visa Status', passportVisaData['visaStatus'] ?? ''),
        _buildLabelAndValue('Expiration Date', passportVisaData['expirationDate'] ?? ''),
      ],
    );
  }
}