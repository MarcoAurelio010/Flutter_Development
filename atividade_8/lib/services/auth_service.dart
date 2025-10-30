import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
    return userCredential;
  }
}