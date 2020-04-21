import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //Collection Reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  final CollectionReference attendanceCollection =
      Firestore.instance.collection('attendance');

  Future updateUserData(
      {String firstName,
      String lastName,
      String subject,
      String indexNum,
      String teacherUid,
      String studentUid,
      String role}) async {
    if (role == 'teacher') {
      return await userCollection.document(uid).setData({
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'subject': subject,
        'role': 'teacher'
      });
    } else {
      return await userCollection.document(uid).setData({
        'attendance': 0,
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'subject': subject,
        'indexNum': indexNum,
        'teacherUid': teacherUid,
        'role': 'student'
      });
    }
  }

  Future getUserData() async {
    dynamic userData = await userCollection.document(uid).get();
    print("getUserData called!");
    return userData;
//    print("Role of user>>>>>>>>>>>>>>>>>>>>"+userData.data['role']);
  }

  Future updateAttendanceData({
    String date,
    String time,
    String index,
    String teacherUid,
    String studentUid,
  }) async {
    return await attendanceCollection.document().setData({
      'date': date,
      'time': time,
      'index': index,
      'teacherUid': teacherUid,
      'studentUid': studentUid
    });
  }
}
