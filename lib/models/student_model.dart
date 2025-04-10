class StudentModel {
  final String id;
  final String firstName;
  final String lastName;
  final String programName;
  final String subprogram;
  final String citizenship;
  final String campus;
  final String address;
  final String contact;
  final String dob;
  final String gender;
  final String programLevel;
  final String middleName;
  final String createdAt;

  StudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.programName,
    required this.subprogram,
    required this.citizenship,
    required this.campus,
    required this.address,
    required this.contact,
    required this.dob,
    required this.gender,
    required this.programLevel,
    required this.middleName,
    required this.createdAt,
  });

  // Factory constructor for creating a StudentModel from JSON
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['studentId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      programName: json['programName'] ?? '',
      subprogram: json['subprogram'] ?? '',
      citizenship: json['citizenship'] ?? '',
      campus: json['campus'] ?? '',
      address: json['address'] ?? '',
      contact: json['contact'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      programLevel: json['programLevel'] ?? '',
      middleName: json['middleName'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  // Convert StudentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'studentId': id,
      'firstName': firstName,
      'lastName': lastName,
      'programName': programName,
      'subprogram': subprogram,
      'citizenship': citizenship,
      'campus': campus,
      'address': address,
      'contact': contact,
      'dob': dob,
      'gender': gender,
      'programLevel': programLevel,
      'middleName': middleName,
      'createdAt': createdAt,
    };
  }

  // Getter for full name
  String get name => '$firstName $middleName $lastName';

  // Getter for program name
  String get program => programName;

  // Getter for subprograms (splitting by comma if there are multiple)
  List<String> get subprograms {
    // If 'subprogram' is a single value, split it; if it's multiple, split by commas
    return subprogram.isNotEmpty ? subprogram.split(',').map((s) => s.trim()).toList() : [];
  }
}
