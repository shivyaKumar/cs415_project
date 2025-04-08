
class SASStaffModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String employmentType;

  SASStaffModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.employmentType,
  });

  // Factory method to create a SAS Staff from a map (e.g., from a database or API)
  factory SASStaffModel.fromMap(Map<String, dynamic> map) {
    return SASStaffModel(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      employmentType: map['employmentType'] ?? '',
    );
  }

  // Convert the SAS Staff to a map (e.g., for saving to a database or API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'employmentType': employmentType,
    };
  }

  // Validate the SAS Staff's details
  static String? validateDetails({
    required String firstName,
    required String lastName,
    required String email,
    required String employmentType,
  }) {
    if (firstName.isEmpty) return 'First name is required.';
    if (lastName.isEmpty) return 'Last name is required.';
    if (email.isEmpty || !email.contains('@')) return 'A valid email is required.';
    if (employmentType.isEmpty) return 'Employment type is required.';
    return null; // No validation errors
  }
}