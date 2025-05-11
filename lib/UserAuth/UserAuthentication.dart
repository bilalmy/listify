import 'package:firebase_auth/firebase_auth.dart';


class UserAuthentication
{
  FirebaseAuth _auth = FirebaseAuth.instance;


  Future<User?> SignUpwithEmailAndPassword(String email, String password) async {
    try {
      UserCredential? credentials= await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return   credentials.user;
    } catch (e) {
      print('Signup failed: $e');
    }
    return null;
  }

  Future<User?> SignInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential? credentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credentials.user;
    } catch (e) {
      print('Login failed: $e');
    }
    return null;
  }

  Future<void> Loggedout() async
  {
    await _auth.signOut();
  }

}

