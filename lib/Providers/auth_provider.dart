import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String? _error;
  bool _isAuthenticated = false;

  UserAuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      _isAuthenticated = user != null;
      notifyListeners();
    });
  }
  
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      _isAuthenticated = true;
      _error = null;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? 'An unknown error occurred';
      _isAuthenticated = false;
    } catch (e) {
      _error = 'An unknown error occurred';
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      if (_user != null) {
        await _firestore.collection('users').doc(_user!.uid).set({
          'name': name,
          'email': email,
        });
      }

      _isAuthenticated = true;
      _error = null;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? 'An unknown error occurred';
      _isAuthenticated = false;
    } catch (e) {
      _error = 'An unknown error occurred';
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      _isAuthenticated = false;
      _error = null;
    } catch (e) {
      _error = 'An unknown error occurred';
    }
    notifyListeners();
  }
}
