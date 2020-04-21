import 'package:attendancemanagerapp/config/size_config.dart';
import 'package:attendancemanagerapp/services/auth.dart';
import 'package:attendancemanagerapp/src/models/qr_data_model.dart';
import 'package:attendancemanagerapp/src/models/student.dart';
import 'package:attendancemanagerapp/src/widgets/submit_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final AuthService _auth = AuthService();
  bool isVisible = false;
  String date, time, _uid;
  Student student;
  QRModel qrModel;

  @override
  void initState() {
    _getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Welcome!', style: Theme.of(context).textTheme.subtitle),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/student_login', (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: SizeConfig.blockSizeVertical * 5),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Make sure to generate QR Code ",
                style: Theme.of(context).textTheme.body2,
                children: <TextSpan>[
                  TextSpan(text: 'on the time ', style: TextStyle(color: Colors.red)),
                  TextSpan(text: 'you enter the class room.'),
                ],
              ),
            ),
                SubmitButton(
                  title: "Generate QR",
                  onSubmit: () {
                    setState(() {
                      isVisible = true;
                    });
                  },
                ),
                Visibility(
                  visible: isVisible,
                  child: QrImage(
                    size: 220,
                    data: _getQRData(),
                  ),
                )
              ],
            ),
          )),
    );
  }

  _getQRData() {
    var timeStamp = new DateTime.now();
    var dateFormatter = new DateFormat('yyyy-MM-dd');
    var timeFormatter = DateFormat('jms');
    date = dateFormatter.format(timeStamp);
    time = timeFormatter.format(timeStamp);
    print(date + " " + time);
    return "success,$date,$time,$_uid";
  }

  Future getUserData(String uid) async {
    await Firestore.instance
        .collection('users')
        .document('$uid')
        .get()
        .then((DocumentSnapshot data) {
      student = Student.fromDocument(data);
      //return student;
    });
  }

//  Future generateQRCode(String myUid) async {
//    getUserData(myUid);
//    qrModel.date = date;
//    qrModel.time = time;
//    qrModel.studentUid = myUid;
//    qrModel.teacherUid = student.teacherUid;
//
//    return qrModel;
//  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _uid = prefs.getString("studentUid");
    });
    print("Student UID>>>>" + _uid);
  }
}
