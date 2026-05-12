import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'app_cache.dart';

class YummyAuth extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _appCache = AppCache();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<bool> get loggedIn async {
    return _firebaseAuth.currentUser != null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _appCache.invalidate();
    notifyListeners();
  }

  Future<String?> signIn(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) return 'Please fill in all fields';
      
      final effectiveEmail = email.contains('@') ? email : '$email@yummy.com';
      await _firebaseAuth.signInWithEmailAndPassword(
        email: effectiveEmail, 
        password: password,
      );
      await _appCache.cacheUser();
      notifyListeners();
      return null; 
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found': return 'No user found for that email.';
        case 'wrong-password': return 'Wrong password provided.';
        case 'invalid-email': return 'The email address is badly formatted.';
        default: return e.message ?? 'An unknown error occurred';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) return 'Please fill in all fields';
      if (password.length < 6) return 'Password should be at least 6 characters';

      final effectiveEmail = email.contains('@') ? email : '$email@yummy.com';
      
      // Try to create user
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: effectiveEmail,
        password: password,
      );
      
      await _appCache.cacheUser();
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message ?? 'Registration failed';
    } catch (e) {
      // Graceful check for Pigeon error: if user is logged in despite exception
      if (_firebaseAuth.currentUser != null) return null;
      return e.toString();
    }
  }
}
