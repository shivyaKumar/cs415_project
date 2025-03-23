import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Example username for the dropdown
  final String username = 'Student';

  static const Color headerTeal = Color(0xFF009999);
  static const Color navbarBlue = Color.fromARGB(255, 8, 45, 87);

  /// A contrasting color for the selected navbar item
  static const Color selectedColor = Color(0xFF005F8F);

  // The horizontal nav items
  final List<String> _labels = [
    'Personal Details',
    'Address',
    'Email & Phone',
    'Emergency Contact',
    'Passport & Visa',
  ];

  // For highlighting which nav item is selected
  int _selectedIndex = 0;

  String? _chosenFileName;

  // Example data maps
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

  Future<void> _openLink(String urlString) async {
    debugPrint('Attempt to open: $urlString');
  }

  // Logout method
  void _logout() {
    debugPrint('User logged out');
    Navigator.pushReplacementNamed(context, '/login'); // Ensure '/login' is defined in your routes.
  }

  // Navbar item builder with a new contrasting selected color
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
        color: isSelected ? selectedColor : navbarBlue,
        child: Text(
          _labels[index],
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildFooter(double screenWidth) {
    final double scaleFactor = screenWidth < 600 ? screenWidth / 600 : 1.0;
    final double footerFontSize = 14 * scaleFactor;
    final double verticalPadding = 8 * scaleFactor;
    final double horizontalPadding = 16 * scaleFactor;
    final double logoWidth = 133 * scaleFactor;
    final double logoHeight = 60 * scaleFactor;

    return Container(
      width: double.infinity,
      color: headerTeal,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => _openLink('https://www.example.com/copyright'),
                      child: Text(
                        'Copyright',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontSize: footerFontSize,
                        ),
                      ),
                    ),
                    SizedBox(width: 8 * scaleFactor),
                    Text(
                      '|',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: footerFontSize,
                      ),
                    ),
                    SizedBox(width: 8 * scaleFactor),
                    InkWell(
                      onTap: () => _openLink('https://www.example.com/contact'),
                      child: Text(
                        'Contact Us',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontSize: footerFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4 * scaleFactor),
                Text(
                  '© Copyright 1968 - 2025. '
                  'All Rights Reserved.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: footerFontSize,
                  ),
                ),
              ],
            ),
          ),
          // Center column (USP Logo)
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/usp_logo.svg',
                width: logoWidth,
                height: logoHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Right column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'The University of the South Pacific',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: footerFontSize,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  'Laucala Campus, Suva, Fiji',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: footerFontSize,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  'Tel: +679 323 1000',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: footerFontSize,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
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
        const Text(
          'Personal Profile',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildPhotoUploadSection(),
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Grab the current route name for highlighting in the dropdown
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Scaffold(
      // AppBar with USP logo + user dropdown
      appBar: AppBar(
        backgroundColor: headerTeal,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SvgPicture.asset(
            'assets/images/usp_logo.svg',
            height: 70,
            width: 90,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, kToolbarHeight),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  // Already on Profile, do nothing
                  break;
                case 'myEnrollment':
                  Navigator.pushNamed(context, '/myEnrollment');
                  break;
                case 'courses':
                  Navigator.pushNamed(context, '/courses');
                  break;
                case 'finance':
                  Navigator.pushNamed(context, '/finance');
                  break;
                case 'logout':
                  _logout();
                  break;
              }
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.person, size: 32, color: Colors.white),
            ),
            itemBuilder: (context) => [
              // The "Hi, Student" line
              PopupMenuItem<String>(
                enabled: false,
                child: Text('Hi, $username'),
              ),
              const PopupMenuDivider(),

              // Profile
              PopupMenuItem<String>(
                value: 'profile',
                // Wrap in Container to color entire row in dark blue if active
                child: Container(
                  color: (currentRoute == '/profile') ? navbarBlue : null,
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: (currentRoute == '/profile')
                          ? Colors.white
                          : Colors.black,
                    ),
                    title: Text(
                      'Profile',
                      style: TextStyle(
                        color: (currentRoute == '/profile')
                            ? Colors.white
                            : Colors.black,
                        fontWeight: (currentRoute == '/profile')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              // My Enrollment
              PopupMenuItem<String>(
                value: 'myEnrollment',
                child: Container(
                  color: (currentRoute == '/myEnrollment') ? navbarBlue : null,
                  child: ListTile(
                    leading: Icon(
                      Icons.how_to_reg,
                      color: (currentRoute == '/myEnrollment')
                          ? Colors.white
                          : Colors.black,
                    ),
                    title: Text(
                      'My Enrollment',
                      style: TextStyle(
                        color: (currentRoute == '/myEnrollment')
                            ? Colors.white
                            : Colors.black,
                        fontWeight: (currentRoute == '/myEnrollment')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              // Courses
              PopupMenuItem<String>(
                value: 'courses',
                child: Container(
                  color: (currentRoute == '/courses') ? navbarBlue : null,
                  child: ListTile(
                    leading: Icon(
                      Icons.menu_book,
                      color: (currentRoute == '/courses')
                          ? Colors.white
                          : Colors.black,
                    ),
                    title: Text(
                      'Courses',
                      style: TextStyle(
                        color: (currentRoute == '/courses')
                            ? Colors.white
                            : Colors.black,
                        fontWeight: (currentRoute == '/courses')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              // Finance
              PopupMenuItem<String>(
                value: 'finance',
                child: Container(
                  color: (currentRoute == '/finance') ? navbarBlue : null,
                  child: ListTile(
                    leading: Icon(
                      Icons.attach_money,
                      color: (currentRoute == '/finance')
                          ? Colors.white
                          : Colors.black,
                    ),
                    title: Text(
                      'Finance',
                      style: TextStyle(
                        color: (currentRoute == '/finance')
                            ? Colors.white
                            : Colors.black,
                        fontWeight: (currentRoute == '/finance')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              const PopupMenuDivider(),

              // Logout
              PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: const Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),

      // Body with horizontal navbar + main content + pinned footer
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Centered NAVBAR below the AppBar
                    Container(
                      width: double.infinity,
                      color: navbarBlue,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: ConstrainedBox(
                          // Optional: limit the navbar's max width for a cleaner, centered look
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_labels.length, (index) {
                                return _buildNavButton(index);
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // MAIN CONTENT
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1040),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
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

                    // FOOTER
                    buildFooter(screenWidth),
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
