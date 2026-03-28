/// Form validation utilities
class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vul uw e-mailadres in';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Voer een geldig e-mailadres in';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vul uw wachtwoord in';
    }
    if (value.length < 6) {
      return 'Wachtwoord moet minimaal 6 tekens zijn';
    }
    return null;
  }

  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Dit veld'} is verplicht';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vul uw telefoonnummer in';
    }
    final phoneRegex = RegExp(r'^[\+]?[0-9]{9,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'Voer een geldig telefoonnummer in';
    }
    return null;
  }
}
