class AppValidators {
  static String? required(
    String? value, {
    String message = 'This field is required',
  }) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmed = value.trim().toLowerCase();

    // Basic structural checks
    if (trimmed.endsWith('.') ||
        trimmed.endsWith('@') ||
        trimmed.startsWith('.')) {
      return 'Enter valid email';
    }

    // Must contain exactly one @
    final atIndex = trimmed.indexOf('@');
    if (atIndex < 0 || atIndex != trimmed.lastIndexOf('@')) {
      return 'Enter valid email';
    }

    final local = trimmed.substring(0, atIndex); // part before @
    final domain = trimmed.substring(atIndex + 1); // part after @

    // Local part: 1–64 chars, no consecutive dots, no leading/trailing dot
    if (local.isEmpty || local.length > 64) return 'Enter valid email';
    if (local.startsWith('.') || local.endsWith('.'))
      return 'Enter valid email';
    if (local.contains('..')) return 'Enter valid email';
    if (!RegExp(r'^[a-z0-9._%+\-]+$').hasMatch(local))
      return 'Enter valid email';

    // Domain: must have at least one dot
    if (!domain.contains('.')) return 'Enter valid email';
    if (domain.startsWith('.') || domain.endsWith('.'))
      return 'Enter valid email';
    if (domain.contains('..')) return 'Enter valid email';

    final domainParts = domain.split('.');
    // TLD (last part) must be 2–63 alpha chars only
    final tld = domainParts.last;
    if (tld.length < 2 || tld.length > 63) return 'Enter valid email';
    if (!RegExp(r'^[a-z]+$').hasMatch(tld)) return 'Enter valid email';

    // Every domain label before the TLD must be at least 2 chars
    // e.g. "g" in "g.com" is rejected; "gmail" in "gmail.com" is fine
    for (int i = 0; i < domainParts.length - 1; i++) {
      final label = domainParts[i];
      if (label.length < 2) return 'Enter valid email';
      if (!RegExp(r'^[a-z0-9\-]+$').hasMatch(label)) return 'Enter valid email';
      if (label.startsWith('-') || label.endsWith('-'))
        return 'Enter valid email';
    }

    return null;
  }

  static String? emailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field is required';
    }

    final input = value.trim().replaceAll(' ', '').replaceAll('-', '');

    // Try email validation first
    if (email(input) == null) return null;

    // Try Egyptian phone
    final phoneRegex = RegExp(r'^(\+20|0)?1[0125][0-9]{8}$');
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
    final trimmed = value.trim();
    if (trimmed.length != 11) {
      return 'Phone number must be 11 digits';
    }
    // Egyptian mobile: 010, 011, 012, 015
    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(trimmed)) {
      return 'Enter valid Egyptian phone number';
    }
    return null;
  }

  /// Login password — only checks that the field is not empty.
  /// Length and complexity rules are NOT enforced here — the backend
  /// returns the appropriate error if credentials are wrong.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  /// Sign-up / reset password — enforces full complexity rules.
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'At least 8 characters';
    }
    if (value.length > 30) {
      return 'Password must be at most 30 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Add uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Add a number';
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
    if (value.trim().length > 10) {
      return 'Name must be at most 10 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters';
    }
    return null;
  }
}
