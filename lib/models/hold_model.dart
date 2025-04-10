class Hold {
  final String studentID;
  final String reason;
  final String status;

  Hold({
    required this.studentID,
    required this.reason,
    required this.status,
  });

  factory Hold.fromJson(Map<String, dynamic> json) {
    return Hold(
      studentID: json['studentID'],
      reason: json['reason'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentID': studentID,
      'reason': reason,
      'status': status,
    };
  }
}
