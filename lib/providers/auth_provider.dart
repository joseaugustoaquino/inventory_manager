import 'package:flutter/material.dart';
import 'package:inventory_manager/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  AuthProvider() {
    _auth.authStateChanges().listen((user) async {
      if (user == null) {
        _currentUser = null;
        notifyListeners();
      } else {
        final doc = await _db.collection('usuarios').doc(user.uid).get();
        if (doc.exists) {
          _currentUser = UserModel.fromFirestore(doc.data()!, doc.id);
        } else {
          _currentUser = UserModel(
            id: user.uid,
            name: user.email?.split('@').first ?? 'Usuário',
            email: user.email ?? '',
            phone: '',
          );
          await _db.collection('usuarios').doc(user.uid).set(_currentUser!.toJson(), SetOptions(merge: true));
        }
        notifyListeners();
      }
    });
  }
  
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Falha na autenticação';
      _isLoading = false;
      notifyListeners();
      return false;
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
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final uid = cred.user!.uid;
      final userModel = UserModel(id: uid, name: name, email: email, phone: phone);
      await _db.collection('usuarios').doc(uid).set({
        ...userModel.toJson(),
        'phone': phone,
      }, SetOptions(merge: true));
      _currentUser = userModel;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Falha ao cadastrar';
      _isLoading = false;
      notifyListeners();
      return false;
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
      await _auth.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Falha ao enviar recuperação';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Erro ao enviar email de recuperação: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> updatePassword(String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _auth.currentUser!.updatePassword(newPassword);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Falha ao alterar senha';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Erro ao alterar senha: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> updatePasswordWithReauth(String currentPassword, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final user = _auth.currentUser!;
      final email = user.email!;
      final cred = EmailAuthProvider.credential(email: email, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _errorMessage = 'Reautenticação necessária. Faça login novamente.';
      } else {
        _errorMessage = e.message ?? 'Falha ao alterar senha';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Erro ao alterar senha: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() async {
    await _auth.signOut();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}