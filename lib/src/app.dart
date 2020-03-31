import 'package:attendancemanagerapp/src/screens/choose_role.dart';
import 'package:attendancemanagerapp/src/screens/student_dashboard.dart';
import 'package:attendancemanagerapp/src/screens/student_login.dart';
import 'package:attendancemanagerapp/src/screens/teacher_dashboard.dart';
import 'package:attendancemanagerapp/src/screens/teacher_login.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.orange,
        accentColor: Colors.orangeAccent,
        disabledColor: Colors.grey,

        // Define the default font family.
//        fontFamily: 'Georgia',

        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(
              fontSize: 30.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold),
          subtitle: TextStyle(
            fontSize: 18.0,
            fontStyle: FontStyle.normal,
          ),
          body1: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Hind',
          ),
        ),
      ),
      home: Scaffold(
        body: ChooseRoleView(),
      ),
      routes: <String, WidgetBuilder>{
        '/choose_role': (BuildContext context) => ChooseRoleView(),
        '/student_login': (BuildContext context) => StudentLoginView(),
        '/student_dashboard': (BuildContext context) => StudentDashboard(),
        '/teacher_login': (BuildContext context) => TeacherLoginView(),
        '/teacher_dashboard': (BuildContext context) => TeacherDashboard(),

      },
    );
  }
}
