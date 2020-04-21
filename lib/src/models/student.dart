import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String firstName;
  String lastName;
  String subject;
  String index;
  String uid;
  String teacherUid;
  int attendance;
  String role = 'student';

  Student({
    this.firstName,
    this.lastName,
    this.subject,
    this.index,
    this.teacherUid,
    this.uid,
    this.attendance
  });

  Student.fromDocument(DocumentSnapshot parsedDoc) {
    this.firstName = parsedDoc["firstName"];
    this.lastName = parsedDoc["lastName"];
    this.subject = parsedDoc["subject"];
    this.index = parsedDoc["indexNum"];
    this.teacherUid = parsedDoc["teacherUid"];
    this.uid = parsedDoc["uid"];
    this.attendance = parsedDoc['attendance'];

  }
}
