import 'package:attendancemanagerapp/services/auth.dart';
import 'package:attendancemanagerapp/src/models/student.dart';
import 'package:attendancemanagerapp/src/widgets/custom_drawer.dart';
import 'package:attendancemanagerapp/src/widgets/loading.dart';
import 'package:attendancemanagerapp/src/widgets/popup_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class TeacherDashboard extends StatefulWidget {
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final AuthService _auth = AuthService();

  List<Student> studentList = [];
  String _uid, result, date, time, studentUid;
  bool isLoading = false;

  @override
  void initState() {
    _getPreferences();
    getUser(_uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        name: "Welcome!",
        addStudent: () {
          Navigator.of(context).pushNamed('/add_student');
        },
        logOut: () async {
          await _auth.signOut();
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/teacher_login', (Route<dynamic> route) => false);
        },
      ),
      appBar: AppBar(
        title: Center(
          child: Text('Attendance Manager',
              style: Theme.of(context).textTheme.subtitle),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/teacher_login', (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .where("teacherUid", isEqualTo: _uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Loading();
            default:
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child:
                            Image(image: AssetImage('assets/images/user.png')),
                        maxRadius: 20.0,
                        minRadius: 5.0,
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(document.data['firstName'] +
                          " " +
                          document.data['lastName']),
                      subtitle: Text(document.data['indexNum']),
                      trailing: Text(document.data['attendance'].toString()),
                    ),
                  );
                }).toList(),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text('Scan'),
        onPressed: () async {
          _scanQR();
//          updateAttendance('wRaVBTaRLVMBUsedUjh53Uj7YD63');
//          getUser(_uid);
        },
      ),
    );
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

  Future getUser(String uid) async {
    Firestore.instance
        .collection('users')
        .where("teacherUid", isEqualTo: uid)
        .snapshots()
        .listen(
          (data) => data.documents.forEach(
            (doc) {
              print(data.documents.length);
              Student student = Student.fromDocument(doc);
              studentList.add(student);
            },
          ),
        );
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

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _uid = prefs.getString("teacherUid");
    });
  }
}
