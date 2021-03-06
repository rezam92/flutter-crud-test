import 'package:phone_number/phone_number.dart';

extension ExtString on String? {
  bool get isNotNull => this != null;

  bool get isValidEmail {
    if (this == null) return false;
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this!);
  }

  bool isValidString({int maxLength = 25, int minLength = 2}) {
    if (this == null || this!.isEmpty || this!.length > maxLength || this!.length < minLength) return false;
    final nameRegExp = RegExp(r'^[a-zA-Z0-9]+$');
    return nameRegExp.hasMatch(this!);
  }
}