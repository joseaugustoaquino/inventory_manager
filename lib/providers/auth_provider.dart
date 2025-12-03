import 'package:flutter/material.dart';
import 'package:inventory_manager/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (email == 'admin@fabads.com' && password == '123456') {
        _currentUser = UserModel(
          id: '1',
          name: 'Administrador',
          email: email,
          phone: '(11) 99999-9999',
        );
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Email ou senha incorretos';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao fazer login: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> register(String name, String email, String phone, String password) async { 
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao cadastrar: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao enviar email de recuperação: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}