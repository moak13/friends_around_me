import 'string_util.dart';
import 'package:friends_around_me/extensions/string_extension.dart';

class Validator {
  static String? validateFullName(String? s) {
    if (StringUtil.isEmpty(s)) {
      return "Full name is required";
    }

    List<String>? nameParts = s?.nameParts;
    if (nameParts!.length < 2) {
      return "Please enter both first and last name";
    }

    return null;
  }

  static String? validateEmail(String? s) {
    if (StringUtil.isEmpty(s)) {
      return 'Email cannot be empty';
    } else if (!StringUtil.isValidEmail(s!)) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  static String? validateNewPassword(String? s) {
    if (StringUtil.isEmpty(s)) {
      return 'Password cannot be empty';
    } else if (!StringUtil.hasLowerCase(s!)) {
      return 'Password must contain a lowercase';
    } else if (!StringUtil.hasUpperCase(s)) {
      return 'Password must contain an uppercase';
    } else if (!StringUtil.hasNumber(s)) {
      return 'Password must contain a number';
    } else if (!StringUtil.hasSymbol(s)) {
      return 'Password must contain a symbol';
    } else if (s.length < 8) {
      return 'Password must be atleast eight characters long';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? s) {
    if (StringUtil.isEmpty(s)) {
      return 'Password cannot be empty';
    } else if (s!.length < 8) {
      return 'Password must be greater or equal to eight';
    } else {
      return null;
    }
  }
}
