import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  String index;
  String date;
  String time;

  AttendanceModel({this.index, this.date, this.time});

  AttendanceModel.fromDocument(DocumentSnapshot parsedJson) {
    this.index = parsedJson['index'];
    this.date = parsedJson['date'];
    this.time = parsedJson['time'];

  }
}