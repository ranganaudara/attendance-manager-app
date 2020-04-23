import 'package:attendancemanagerapp/src/models/student.dart';
import 'package:attendancemanagerapp/src/widgets/popup_message.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class NewClass extends StatefulWidget {
  NewClass(this.teacherUid);
  final String teacherUid;

  @override
  _NewClassState createState() => _NewClassState();
}

class _NewClassState extends State<NewClass> {
  List<Student> newStudents = [];
  String result, date, time, studentUid;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today Attendance"),
      ),
      body: ListView.builder(
        itemCount: newStudents == [] ? 0 : newStudents.length,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Image(image: AssetImage('assets/images/user.png')),
                maxRadius: 20.0,
                minRadius: 5.0,
                backgroundColor: Colors.transparent,
              ),
              title: Text(
                  newStudents[i].firstName + " " + newStudents[i].lastName),
              subtitle: Text(newStudents[i].index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text('Scan'),
        onPressed: () async {
          _scanQR();
        },
      ),
    );
  }

  Future getUser(String uid) async {
    Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot ds) {
      // use ds as a snapshot
      Student student = Student.fromDocument(ds);
              setState(() {
                newStudents.add(student);
              });
        print(">>>>>>>>>>>>>>"+newStudents[0].index);
    });
  }

  Future<String> _scanQR() async {
    try {
      ScanResult qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult.rawContent;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result = "Camera permission denied!";
        });
      } else {
        setState(() {
          result = "Uknown Error: $e";
        });
      }
    } on FormatException {
      setState(() {
        result = "QR Code scan incomplete!";
      });
    } catch (e) {
      setState(() {
        result = "Uknown Error: $e";
      });
    }
    _checkQRContent();
  }

  _checkQRContent() {
    List<String> parsedQRData = result.split(',');
    if (parsedQRData[0] == 'success') {
      date = parsedQRData[1];
      time = parsedQRData[2];
      studentUid = parsedQRData[3];
      getUser(studentUid);
      updateAttendance(studentUid);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopupMessage(
            message: "Invalid QR Code!",
            onSubmit: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  Future updateAttendance(String uid) async {
    final DocumentReference studentRef =
        Firestore.instance.document('users/$uid');
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(studentRef);
      if (postSnapshot.exists) {
        await tx.update(studentRef, <String, dynamic>{
          'attendance': postSnapshot.data['attendance'] + 1
        });
      }
    });
  }
}
