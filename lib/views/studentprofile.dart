import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/profile_viewmodel.dart'; // Contains business logic (file picking, logout)
import 'widgets/custom_header.dart';          // Reusable header widget (for AppBar)
import 'widgets/custom_footer.dart';          // Reusable footer widget

/// The Profile screen displays various sections of user information,
/// such as personal details, address, and so on. 
///
/// SOLID:
/// - SRP: Each class has a single responsibility (Profile view is only UI).
/// - DIP: The view depends on an abstraction (ProfileController via Provider).
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Static username (for demonstration)
  final String username = 'Student';

  // Colors used in the horizontal navigation bar.
  static const Color headerTeal = Color(0xFF009999);
  static const Color navbarBlue = Color.fromARGB(255, 8, 45, 87);
  static const Color selectedColor = Color(0xFF005F8F);

  // Horizontal navigation labels for different profile sections.
  final List<String> _labels = [
    'Personal Details',
    'Address',
    'Email & Phone',
    'Emergency Contact',
    'Passport & Visa',
  ];
  int _selectedIndex = 0;

  // Example data maps (these should be replaced by models or data from the ViewModel later)
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

  /// Builds a navigation button for the horizontal nav bar.
  /// When tapped, updates the selected index to display the appropriate section.
  Widget _buildNavButton(int index) {
    final bool isSelected = (index == _selectedIndex);
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // Highlight the selected nav button using a different color.
        color: isSelected ? selectedColor : navbarBlue,
        child: Text(
          _labels[index],
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// Returns the content widget for the current section based on _selectedIndex.
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

  /// Builds the Personal Details section.
  Widget _buildPersonalDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title.
        const Text('Personal Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildPhotoUploadSection(),
        const SizedBox(height: 16),
        // Display various personal data.
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
        // Notice for verification.
        Container(
          width: double.infinity,
          color: const Color.fromARGB(255, 128, 35, 35),
          padding: const EdgeInsets.all(9.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Please Verify', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'If the information given above is incorrect, please contact the Student Administrative Services Office, providing the appropriate documentary evidence.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the photo upload section for the user's passport-size photo.
  /// Uses the ProfileController (ViewModel) to handle file picking.
  Widget _buildPhotoUploadSection() {
    final profileController = Provider.of<ProfileController>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload Passport Size Photo', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                await profileController.pickFile();
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
            // Display the chosen file name or default text if none is selected.
            Text(profileController.chosenFileName ?? 'No file chosen'),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Please ensure that the photo you upload is your true resemblance and is of a passport size. Only JPG files less than 5MB permitted.',
          style: TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            debugPrint('Save clicked for file: ${profileController.chosenFileName}');
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

  /// Helper method to display a label and its corresponding value.
  Widget _buildLabelAndValue(String label, String value) {
    final displayValue = value.isEmpty ? 'N/A' : value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
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

  /// Builds the Address section.
  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildLabelAndValue('Street', addressData['street'] ?? ''),
        _buildLabelAndValue('City', addressData['city'] ?? ''),
        _buildLabelAndValue('State/Province', addressData['stateProvince'] ?? ''),
        _buildLabelAndValue('Country', addressData['country'] ?? ''),
        _buildLabelAndValue('Postal Code', addressData['postalCode'] ?? ''),
      ],
    );
  }

  /// Builds the Email & Phone section.
  Widget _buildEmailPhoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email & Phone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildLabelAndValue('Email', emailPhoneData['email'] ?? ''),
        _buildLabelAndValue('Phone', emailPhoneData['phone'] ?? ''),
      ],
    );
  }

  /// Builds the Emergency Contact section.
  Widget _buildEmergencyContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Emergency Contact', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildLabelAndValue('First Name', emergencyData['firstName'] ?? ''),
        _buildLabelAndValue('Middle Name', emergencyData['middleName'] ?? ''),
        _buildLabelAndValue('Last Name', emergencyData['lastName'] ?? ''),
        _buildLabelAndValue('Relationship', emergencyData['relationship'] ?? ''),
        _buildLabelAndValue('Contact Phone', emergencyData['contactPhone'] ?? ''),
      ],
    );
  }

  /// Builds the Passport & Visa section.
  Widget _buildPassportVisaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Passport & Visa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildLabelAndValue('Passport Number', passportVisaData['passportNumber'] ?? ''),
        _buildLabelAndValue('Visa Status', passportVisaData['visaStatus'] ?? ''),
        _buildLabelAndValue('Expiration Date', passportVisaData['expirationDate'] ?? ''),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness.
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // HEADER
      appBar: const CustomHeader(),

      // The body uses a LayoutBuilder to ensure the content fills available height.
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Horizontal navigation bar for profile sections.
                    Container(
                      width: double.infinity,
                      color: navbarBlue,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_labels.length, (index) => _buildNavButton(index)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Main content area that displays the currently selected section.
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1040),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                              elevation: 4,
                              margin: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: _buildSectionContent(_selectedIndex),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Reusable footer for consistent look across pages.
                    CustomFooter(screenWidth: screenWidth),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
