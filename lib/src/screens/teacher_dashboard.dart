import 'package:attendancemanagerapp/services/auth.dart';
import 'package:flutter/material.dart';

class TeacherDashboard extends StatefulWidget {
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Manager',
            style: Theme.of(context).textTheme.subtitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
//              Navigator.of(context).pushNamedAndRemoveUntil('/teacher_login', (Route<dynamic> route) => false);
            },
          )
        ],
      ),
    );
  }
}
