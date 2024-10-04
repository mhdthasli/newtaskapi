import 'package:firebase_auth/firebase_auth.dart';

class FireHelper1 {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up method
  Future<String?> signUp({required String mail, required String password}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
      print('User created: ${userCredential.user?.email}');
      return null; // No error
    } catch (e) {
      print('Error during sign-up: $e');
      return e.toString(); // Return the error message
    }
  }

  // Sign in method
  Future<String?> signIn({required String mail, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: mail, password: password);
      return null; // success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message; // Return any other Firebase-specific error message
      }
    } catch (e) {
      return 'An error occurred: ${e.toString()}';
    }
  }
}
