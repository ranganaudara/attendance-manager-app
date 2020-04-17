import 'package:attendancemanagerapp/services/auth.dart';
import 'package:attendancemanagerapp/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final AuthService _auth = AuthService();
  bool isVisible = false;
  String date, time;

  @override
  Widget build(BuildContext context) {

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
                    data: _getDateNTime(),
                  ),
                )
              ],
            ),
          )),
    );
  }

  _getDateNTime() {
    var timeStamp = new DateTime.now();
    var dateFormatter = new DateFormat('yyyy-MM-dd');
    var timeFormatter = DateFormat('jms');
    date = dateFormatter.format(timeStamp);
    time = timeFormatter.format(timeStamp);
    return "$date $time";
  }
}
