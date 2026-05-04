class AppValidators {
  static String? required(String? value, {String message = 'This field is required'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter valid email';
    }

    return null;
  }

  static String? emailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field is required';
    }

    final input = value.trim().replaceAll(' ', '').replaceAll('-', '');

    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');

    final phoneRegex = RegExp(r'^(\+20|0)?1[0125][0-9]{8}$');

    if (emailRegex.hasMatch(input)) return null;

    if (phoneRegex.hasMatch(input)) return null;

    return 'Enter valid email or phone';
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    final regex = RegExp(r'^[a-zA-Z0-9_-]+$');

    if (!regex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, _ and -';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone is required';
    }
    if (value.length != 11) {
      return 'Phone number must be 11 digits';
    }
    final phoneRegex = RegExp(r'^(\+20|0)?1[0-5][0-9]{8}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Enter valid phone number';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'At least 8 characters';
    }

    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? minLength(String? value, int min) {
    if (value == null || value.length < min) {
      return 'Must be at least $min characters';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters';
    }
    return null;
  }
}