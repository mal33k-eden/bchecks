import 'package:bchecks/models/owner.dart';
import 'package:bchecks/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Register with email and password
  Future registerUser(
      {required String email,
      required String password,
      required String nickname}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      DataBaseService(uid: userCredential.user!.uid)
          .updateUserData(nickname, email);
      return userCredential;
    } on FirebaseAuthException catch (fireEx) {
      if (fireEx.code == "weak-password") {
        return 'The password provided is too much';
      } else if (fireEx.code == 'email-already-in-use') {
        return 'The account already exists for the email';
      }
    } catch (e) {
      return 'Error!';
    }
  }

  //SIGNIN USER
  Future signinUser({required String email, required String password}) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (fireEx) {
      if (fireEx.code == 'user-not-found') {
        return 'No user found for that email';
      } else if (fireEx.code == 'wrong-password') {
        return 'Wrong password provided for that user';
      }
    } catch (fireEx) {
      print(fireEx);
      return 'Unable to sign user in';
    }
  }

  //signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return 'Error signin out';
    }
  }

  //convert auth details to user models

  Owner? _userFromFireAuth(User? userCredential) {
    return userCredential != null
        ? Owner(
            uid: userCredential.uid,
            nickname: userCredential.uid,
            email: userCredential.uid)
        : null;
  }

  //stream auth changes activity
  Stream<Owner?> get user {
    return _auth.authStateChanges().map(_userFromFireAuth);
  }
}
