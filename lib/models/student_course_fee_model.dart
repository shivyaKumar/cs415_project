class StudentCourseFee {
  final String studentID;
  final double amount;
  final String dueDate;

  StudentCourseFee({
    required this.studentID,
    required this.amount,
    required this.dueDate,
  });

  factory StudentCourseFee.fromJson(Map<String, dynamic> json) {
    return StudentCourseFee(
      studentID: json['studentID'],
      amount: json['amount'],
      dueDate: json['dueDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentID': studentID,
      'amount': amount,
      'dueDate': dueDate,
    };
  }
}
