
class Student {
  final String firstName;
  final String? middleName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String citizenship;
  final String program;
  final String studentLevel;
  final String campus;

  Student({
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.citizenship,
    required this.program,
    required this.studentLevel,
    required this.campus,
  });

  // Factory method to create a Student object from a Map (e.g., for JSON parsing)
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      firstName: map['firstName'],
      middleName: map['middleName'],
      lastName: map['lastName'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      gender: map['gender'],
      citizenship: map['citizenship'],
      program: map['program'],
      studentLevel: map['studentLevel'],
      campus: map['campus'],
    );
  }

  // Method to convert a Student object to a Map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'citizenship': citizenship,
      'program': program,
      'studentLevel': studentLevel,
      'campus': campus,
    };
  }

  // Method to validate the student data
  static String? validateField(String? value, {bool isRequired = true}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return "Required";
    }
    return null;
  }
}