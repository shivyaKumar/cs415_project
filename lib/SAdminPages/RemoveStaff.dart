import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RemoveStaffPage extends StatefulWidget {
  const RemoveStaffPage({super.key});

  @override
  _RemoveStaffPageState createState() => _RemoveStaffPageState();
}

class _RemoveStaffPageState extends State<RemoveStaffPage> {
  // Flag to indicate whether Managers or Staffs is selected
  bool isManagerSelected = true;

  final List<Map<String, String>> managers = [
    {
      "firstName": "John",
      "lastName": "Doe",
      "email": "john.doe@example.com",
      "qualification": "MBA"
    },
    {
      "firstName": "Jane",
      "lastName": "Smith",
      "email": "jane.smith@example.com",
      "qualification": "PhD"
    },
    {
      "firstName": "Michael",
      "lastName": "Brown",
      "email": "michael.brown@example.com",
      "qualification": "BSc"
    },
  ];

  final List<Map<String, String>> staffs = [
    {
      "firstName": "Alice",
      "lastName": "Johnson",
      "email": "alice.johnson@example.com",
      "qualification": "BA"
    },
    {
      "firstName": "Bob",
      "lastName": "Williams",
      "email": "bob.williams@example.com",
      "qualification": "MA"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Select the correct list based on the selected category
    final List<Map<String, String>> currentList =
        isManagerSelected ? managers : staffs;

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Column(
        children: [
          // Card selection for Managers and Staffs
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSelectionCard(
                  title: "Managers",
                  isSelected: isManagerSelected,
                  onTap: () {
                    setState(() {
                      isManagerSelected = true;
                    });
                  },
                ),
                const SizedBox(width: 16),
                _buildSelectionCard(
                  title: "Staffs",
                  isSelected: !isManagerSelected,
                  onTap: () {
                    setState(() {
                      isManagerSelected = false;
                    });
                  },
                ),
              ],
            ),
          ),
          // DataTable for selected category (Managers or Staffs)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:
                      WidgetStateColor.resolveWith((states) => Colors.teal),
                  columns: const [
                    DataColumn(
                      label: Text('First Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    DataColumn(
                      label: Text('Last Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    DataColumn(
                      label: Text('Email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    DataColumn(
                      label: Text('Qualification',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    DataColumn(label: Text('Remove')),
                  ],
                  rows: currentList
                      .map(
                        (staffOrManager) => DataRow(
                          cells: [
                            DataCell(Text(staffOrManager["firstName"]!)),
                            DataCell(Text(staffOrManager["lastName"]!)),
                            DataCell(Text(staffOrManager["email"]!)),
                            DataCell(Text(staffOrManager["qualification"]!)),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () {
                                  // Remove staff or manager
                                  setState(() {
                                    currentList.remove(staffOrManager);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  // Helper method to create cards for Managers and Staffs
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
                  Text(
                    'The University of the South Pacific',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Laucala Campus, Suva, Fiji',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Tel: +679 323 1000',
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
    print('Opening link: $url');
  }
}
