import 'package:attendancemanagerapp/services/auth.dart';
import 'package:attendancemanagerapp/src/wrapper.dart';
import 'package:attendancemanagerapp/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
