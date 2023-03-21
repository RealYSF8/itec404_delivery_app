import 'package:firebase_auth/firebase_auth.dart';

Future<bool> validateLogin(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      return false;
    } else {
      throw e;
    }
  }
}
