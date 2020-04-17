import 'package:attendancemanagerapp/config/size_config.dart';
import 'package:attendancemanagerapp/src/models/user.dart';
import 'package:attendancemanagerapp/src/widgets/square_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseRoleScreen extends StatefulWidget {
  @override
  _ChooseRoleScreenState createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {

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
              Text(
                'Choose your role...',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 5),
              SquareButton(
                title: 'Student',
                icon: Icons.child_care,
                onPressed: () {
                  if (user == null) {
                        Navigator.popAndPushNamed(context, '/student_login');
                  } else {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/student_dashboard', (Route<dynamic> route) => false);
                  }
                },
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 5),
              SquareButton(
                title: 'Teacher',
                icon: Icons.school,
                onPressed: () {
                  if (user == null) {
                    Navigator.of(context).pushNamed('/teacher_login');
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/teacher_dashboard', (Route<dynamic> route) => false);
                  }
                },
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 5)
            ],
          ),
        ),
      ),
    );
  }
}
