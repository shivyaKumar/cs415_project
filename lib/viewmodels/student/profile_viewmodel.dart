import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ProfileController with ChangeNotifier {
  String? chosenFileName;
  
  // Launch file picker for a passport-size photo.
  Future<String?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      chosenFileName = result.files.single.name;
      notifyListeners();
      return chosenFileName;
    }
    return null;
  }
  
  // Logout action.
  void logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
