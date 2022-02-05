import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  registerNewUser(email, password) async {
    try {
       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      if(userCredential.user != null) {
        FirebaseFirestore.instance.collection("users").doc(userCredential.user?.uid).set(
          {
            "email": email,
            "password": password
          }
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  doLogin(email, password) async {
    try {
      UserCredential? user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      if(user.user != null) {
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    } 
  }

}