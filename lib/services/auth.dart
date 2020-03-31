import 'package:attendancemanagerapp/src/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object
  User _userFromFirebase(FirebaseUser user){
    return user != null ? User(uid: user.uid): null;
  }

  // sign in anonymous
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

//sign in with email and password

//reg with email and password

//sign out

}