import 'package:email_validator/email_validator.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    if (!EmailValidator.validate(value)) {
      return 'Digite um email válido';
    }
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
  
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    if (value.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }
  
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }
    // Regex simples para validar telefone brasileiro
    final phoneRegex = RegExp(r'^\([1-9]{2}\) [9]{0,1}[0-9]{4}-[0-9]{4}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Digite um telefone válido (ex: (11) 99999-9999)';
    }
    return null;
  }
  
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value != password) {
      return 'Senhas não coincidem';
    }
    return null;
  }
}