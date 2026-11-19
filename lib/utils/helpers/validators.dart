class Validators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }

    if (value.trim().length < 2) {
      return 'Name must contain at least 2 characters';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final pattern = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!pattern.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  static String? confirmPassword(
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? cnic(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your CNIC';
    }

    final pattern = RegExp(r'^\d{5}-?\d{7}-?\d{1}$');

    if (!pattern.hasMatch(value.trim())) {
      return 'Enter a valid 13-digit CNIC';
    }

    return null;
  }

  static String? license(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your driving license number';
    }

    return null;
  }
}