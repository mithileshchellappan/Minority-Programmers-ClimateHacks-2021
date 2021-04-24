import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      print("called");
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _firebaseAuth.currentUser.uid.toString();
    } catch (e) {
      if (e is PlatformException) {
        print(e.code);
        return e.code;
      }
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _firebaseAuth.currentUser.uid.toString();
    } catch (e) {
      return e;
    }
  }

  Future<String> uid() async {
    return _firebaseAuth.currentUser.uid.toString();
  }

  Future<String> resetPassword(_email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: _email);
      print("password reset mail sent");
      return "Success";
    } catch (e) {
      print("process failed");
      return "Failed";
    }
  }
}
