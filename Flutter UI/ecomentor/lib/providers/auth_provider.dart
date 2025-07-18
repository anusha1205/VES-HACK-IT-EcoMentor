import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  User? _firebaseUser;
  UserModel? _user;
  bool _isLoading = false;

  User? get firebaseUser => _firebaseUser;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _firebaseUser != null;

  AuthProvider() {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _firebaseUser = firebaseUser;
    if (firebaseUser != null) {
      _user = await _userService.getUser(firebaseUser.uid);
    } else {
      _user = null;
    }
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signInWithEmail(email, password);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUpWithEmail(
      String email, String password, String name) async {
    _setLoading(true);
    try {
      final credential = await _authService.signUpWithEmail(email, password);
      final user = UserModel(
        uid: credential.user!.uid,
        email: email,
        name: name,
      );
      await _userService.createUser(user);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      final credential = await _authService.signInWithGoogle();
      final user = await _userService.getUser(credential.user!.uid);
      if (user == null) {
        final newUser = UserModel(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          name: credential.user!.displayName ?? 'User',
          photoUrl: credential.user!.photoURL,
        );
        await _userService.createUser(newUser);
      }
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
