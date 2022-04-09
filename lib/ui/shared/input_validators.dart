class Validator {
  static String? isEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  static String? isValidEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Field cannot be empty";
    }
    return value.isValidEmail ? null : "Not a valid email";
  }

  static String? isValidPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Field cannot be empty";
    }
    String toReturn = "";
    if (!value.containsOneUppercase) {
      toReturn += "\n Must contain one uppercase letter";
    }
    if (!value.containsOneLowercase) {
      toReturn += "\n Must contain one lowercase letter";
    }
    if (!value.containsOneDigit) {
      toReturn += "\n Must contain one numeric digit";
    }
    if (!value.containsOneSpecial) {
      toReturn += "\n Must contain one special character, without spaces";
    }
    if (!value.isOfMinimumLength(6)) {
      toReturn += "\n Must be at least 6 characters";
    }
    return toReturn.isEmpty ? null : toReturn;
  }

  static String? isValidUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Field cannot be empty";
    }
    return value.isValidUsername ? null : "Not a valid username";
  }

  static String? isValidScreenName(String? value) {
    if (value == null || value.isEmpty) {
      return "Field cannot be empty";
    }
    return value.isValidUsername ? null : "Not a valid screen name";
  }

  static String? isValidPairingCodeFormat(String? value) {
    if (value == null || value.isEmpty) {
      return "Field cannot be empty";
    }
    return value.isValidPairingCodeFormat ? null : "The format is incorrect";
  }
}

extension StringValidators on String {
  bool get isValidEmail {
    // Regex taken from:
    // https://stackoverflow.com/questions/16800540/validate-email-address-in-dart/16888554#16888554
    // Posted by user Airon Tark
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  // Password contains a minimum of 6 characters
  // Contain at least one:
  //   Uppercase letter (A-Z)
  //   Lowercase letter (a-z)
  //   Numeric digit (0-9)
  //   Special character (~`!@#$%^&*()_+={[}]|\:;"'<,>.?/)
  // Contain no other types of characters, symbols, or spaces
  bool get containsOneUppercase {
    final passwordRegExp = RegExp(r'[A-Z]');
    return passwordRegExp.hasMatch(this);
  }

  bool get containsOneLowercase {
    final passwordRegExp = RegExp(r'[a-z]');
    return passwordRegExp.hasMatch(this);
  }

  bool get containsOneDigit {
    final passwordRegExp = RegExp(r'[0-9]');
    return passwordRegExp.hasMatch(this);
  }

  bool get containsOneSpecial {
    final passwordRegExp = RegExp(r'[^A-Za-z0-9]');
    return passwordRegExp.hasMatch(this) && containsNoSpaces;
  }

  bool get containsNoSpaces {
    final passwordRegExp = RegExp(r'^\S*$');
    return passwordRegExp.hasMatch(this);
  }

  // Username contains a minimum of 3 characters
  // Contain only:
  //   Uppercase letters (A-Z)
  //   Lowercase letters (a-z)
  //   Numeric digits (0-9)
  // Contain no other types of characters, symbols, or spaces
  bool get isValidUsername {
    // Regex taken from:
    // https://stackoverflow.com/questions/49757486/how-to-use-regex-in-dart
    final nameRegExp = RegExp(r'^[a-zA-Z0-9]+$');
    return nameRegExp.hasMatch(this) && isOfMinimumLength(3);
  }

  // Valid pairing code contains uppercase letters and digits, with a length of 6
  bool get isValidPairingCodeFormat {
    // Regex taken from:
    // https://stackoverflow.com/questions/49757486/how-to-use-regex-in-dart
    final nameRegExp = RegExp(r'^[A-Z0-9]+$');
    return nameRegExp.hasMatch(this) && length==6;
  }

  bool isOfMinimumLength(int length) {
    return this.length > length - 1;
  }
}
