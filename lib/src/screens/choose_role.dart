import 'package:attendancemanagerapp/config/size_config.dart';
import 'package:attendancemanagerapp/src/models/user.dart';
import 'package:attendancemanagerapp/src/screens/student_dashboard.dart';
import 'package:attendancemanagerapp/src/screens/student_login.dart';
import 'package:attendancemanagerapp/src/widgets/square_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseRoleView extends StatefulWidget {
  @override
  _ChooseRoleViewState createState() => _ChooseRoleViewState();
}

class _ChooseRoleViewState extends State<ChooseRoleView> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    SizeConfig().init(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: SizeConfig.blockSizeVertical * 5),
              Text('Choose your role...', style: Theme.of(context).textTheme.title,),
              SizedBox(height: SizeConfig.blockSizeVertical * 5),
              SquareButton(
                  title: 'Student',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/student_login');
                  },
                  icon: Icons.child_care),
              SizedBox(height: SizeConfig.blockSizeVertical * 5),
              SquareButton(
                  title: 'Teacher', onPressed: () {
                if(user == null){
                  Navigator.of(context).pushNamed('/teacher_login');
                } else {
                  Navigator.of(context).pushNamed('/teacher_dashboard');
                }

              }, icon: Icons.school),
              SizedBox(height: SizeConfig.blockSizeVertical * 5)
            ],
          ),
        ),
      ),
    );
  }
}
