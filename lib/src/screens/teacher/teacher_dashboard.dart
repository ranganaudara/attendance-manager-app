import 'package:attendancemanagerapp/services/auth.dart';
import 'package:attendancemanagerapp/src/models/student.dart';
import 'package:attendancemanagerapp/src/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'new_class.dart';
import 'number_of_days_tab.dart';
import 'percentage_tab.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.today),
                text: 'Number of Days',
              ),
              Tab(
                icon: Icon(Icons.timeline),
                text: 'Percentage',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            numberOfDays(_uid),
            PercentageTab(_uid)
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('Add Class'),
          onPressed: () {
            updateClassData(_uid);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewClass(_uid),
              ),
            );
          },
        ),
      ),
    );
  }

  Future updateClassData(String teacherUid) async {
    final DocumentReference studentRef =
    Firestore.instance.document('classes/$teacherUid');
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(studentRef);
      if (postSnapshot.exists) {
        await tx.update(studentRef, <String, dynamic>{
          'classDays': postSnapshot.data['classDays'] + 1
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
