import 'package:attendancemanagerapp/services/database.dart';
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

//Sign In
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      FirebaseUser user = result.user;

      dynamic userData = await DatabaseService(uid:user.uid).getUserData();
      return userData;

    } catch (e) {

      return Future.error(e);

    }
  }

  //Teacher Registration
  Future registerTeacher({
    String email,
    String password,
    String firstName,
    String lastName,
    String subject,
  }) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      FirebaseUser user = result.user;

      //create new document for the user
      await DatabaseService(uid:user.uid).updateUserData(
        firstName: firstName,
        lastName: lastName,
        subject: subject,
        role: 'teacher'
      );

      //create new class for teacher
      await DatabaseService(uid:user.uid).createClass();

      return result;
    } catch (e) {
      return Future.error(e);
    }
  }

//Student Registration
  Future registerStudent({
    String email,
    String password,
    String firstName,
    String lastName,
    String subject,
    String indexNum,
    String teacherUid,
  }) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      FirebaseUser user = result.user;

      //create new document for the user
      await DatabaseService(uid:user.uid).updateUserData(
        firstName: firstName,
        lastName: lastName,
        subject: subject,
        indexNum: indexNum,
        teacherUid: teacherUid,
        role:'student'
      );

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

  Future getTeacherData(String uid) async {
    DatabaseService(uid: uid).getUserData();
  }
}
