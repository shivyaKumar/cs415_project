
class SASManagerModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String qualification;
  final String fieldOfQualification;

  SASManagerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.qualification,
    required this.fieldOfQualification,
  });

  // Factory method to create a SAS Manager from a map (e.g., from a database or API)
  factory SASManagerModel.fromMap(Map<String, dynamic> map) {
    return SASManagerModel(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      qualification: map['qualification'] ?? '',
      fieldOfQualification: map['fieldOfQualification'] ?? '',
    );
  }

  // Convert the SAS Manager to a map (e.g., for saving to a database or API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'qualification': qualification,
      'fieldOfQualification': fieldOfQualification,
    };
  }

  // Validate the SAS Manager's details
  static String? validateDetails({
    required String firstName,
    required String lastName,
    required String email,
    required String qualification,
    required String fieldOfQualification,
  }) {
    if (firstName.isEmpty) return 'First name is required.';
    if (lastName.isEmpty) return 'Last name is required.';
    if (email.isEmpty || !email.contains('@')) return 'A valid email is required.';
    if (qualification.isEmpty) return 'Qualification is required.';
    if (fieldOfQualification.isEmpty) return 'Field of qualification is required.';
    return null; // No validation errors
  }
}