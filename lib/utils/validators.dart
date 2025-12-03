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
    // Remove tudo que não é dígito e valida apenas os 11 números
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) {
      return 'Digite um telefone válido com 11 dígitos. Ex: (11) 99999-9999';
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
  
  static String? validateCep(String? value) {
    final v = (value ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    if (v.isEmpty) return 'Informe o CEP';
    if (v.length != 8) return 'CEP deve ter 8 dígitos';
    return null;
  }

  static String? validateBarcode(String? value) {
    final v = (value ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    if (v.isEmpty) return 'Informe o código de barras';
    if (v.length < 8 || v.length > 14) return 'Código deve ter 8–14 dígitos';
    return null;
  }
}