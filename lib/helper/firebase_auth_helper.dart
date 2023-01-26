import 'package:firebase_auth/firebase_auth.dart';

class FireBaseAuthHelper {
  FireBaseAuthHelper._();
  static final FireBaseAuthHelper fireBaseAuthHelper = FireBaseAuthHelper._();
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //------------------------------------------------------------------------
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

//------------------------------------------------------------------------
  Future<User?> registerUser(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          print("Weak Password");
          break;
        case 'email-already-in-use':
          print("Exist");
          break;
      }
    }
    return null;
  }

//------------------------------------------------------------------------
  Future<User?> loginUser(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          print("wrong");
          break;
        case 'user-not-found':
          print("not created");
          break;
      }
    }
    return null;
  }
}
