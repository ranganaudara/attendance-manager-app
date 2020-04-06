import 'package:attendancemanagerapp/src/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object
  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
//        .map((FirebaseUser user) => _userFromFirebase(user));
        .map(_userFromFirebase);
  }

  // sign in anonymous
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print("Error:");
      print(e.toString());
      return null;
    }
  }

//sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
//      FirebaseUser user = result.user;
//      return _userFromFirebase(user);
    return result;
    } catch (e) {
      return Future.error(e);
    }
  }

//register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User>>>:"+result.user.uid);
//      FirebaseUser user = result.user;
//      return _userFromFirebase(user);
    return result;
    } catch (e) {
      return Future.error(e);
    }
  }

//sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
