import 'package:firebase_database/firebase_database.dart';
import 'models/student_course_fee_model.dart';
import 'models/hold_model.dart';
import 'models/student_model.dart';

class FirebaseService {
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Push course fees to Firebase
  static Future<void> pushCourseFees(String studentID, double amount, String dueDate) async {
    DatabaseReference feesRef = _database.child('student_course_fee').push();
    await feesRef.set({
      'studentID': studentID,
      'amount': amount,
      'dueDate': dueDate,
    });
    print('✅ Course fee added for student $studentID');
  }

  // Push holds to Firebase
  static Future<void> pushHold(String studentID, String reason, String status) async {
    DatabaseReference holdsRef = _database.child('holds').push();
    await holdsRef.set({
      'studentID': studentID,
      'reason': reason,
      'status': status,
    });
    print('✅ Hold added for student $studentID');
  }

  // Fetch course fees based on studentId
  static Future<List<StudentCourseFee>> fetchCourseFees(String studentId) async {
    final snapshot = await _database
        .child('student_course_fee')
        .orderByChild('studentID')
        .equalTo(studentId)
        .get();

    List<StudentCourseFee> feesList = [];
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        feesList.add(StudentCourseFee.fromJson(Map<String, dynamic>.from(value)));
      });
    }

    return feesList;
  }

  // Fetch holds based on studentId
  static Future<List<Hold>> fetchHolds(String studentId) async {
    final snapshot = await _database
        .child('holds')
        .orderByChild('studentID')
        .equalTo(studentId)
        .get();

    List<Hold> holdsList = [];
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        holdsList.add(Hold.fromJson(Map<String, dynamic>.from(value)));
      });
    }

    return holdsList;
  }

  // Fetch student info (optional if you're storing student data in Firebase)
  static Future<StudentModel> fetchStudentInfo(String studentId) async {
    final snapshot = await _database.child('students/$studentId').get();
    if (snapshot.exists) {
      return StudentModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    } else {
      throw Exception('Student not found for ID $studentId');
    }
  }

  // Optional: Push student info if needed
  static Future<void> pushStudent(StudentModel student) async {
    await _database.child('students/${student.id}').set(student.toJson());
    print('✅ Student data saved for ${student.id}');
  }
}
