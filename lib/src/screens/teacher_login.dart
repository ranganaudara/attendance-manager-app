import 'package:attendancemanagerapp/config/size_config.dart';
import 'package:attendancemanagerapp/services/auth.dart';
import 'package:attendancemanagerapp/src/widgets/input_field.dart';
import 'package:attendancemanagerapp/src/widgets/logo_thumb.dart';
import 'package:attendancemanagerapp/src/widgets/submit_button.dart';
import 'package:attendancemanagerapp/src/widgets/text_button.dart';
import 'package:flutter/material.dart';

class TeacherLoginView extends StatefulWidget {
  @override
  _TeacherLoginViewState createState() => _TeacherLoginViewState();
}

class _TeacherLoginViewState extends State<TeacherLoginView> {

  final AuthService _auth = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  final _passwordFieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: SizeConfig.screenHeight * 0.20),
                  LogoThumb('assets/images/teacher_login.png'),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  Text(
                    'Sign in as Teacher',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 5),
                  TextInputField(
                    isPassword: false,
                    labelText: 'Email',
                    onSaved: (input) => _email = input,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide an email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  TextInputField(
                    isPassword: true,
                    fieldKey: _passwordFieldKey,
                    labelText: 'Password',
                    onSaved: (input) => _password = input,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide an password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  SubmitButton(
                    title: 'Sign in',
                    onSubmit: signIn,
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2),
                  Text(
                    'Are you a student?',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  TextButton(
                    title: 'click here',
                    onSubmit: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/choose_role', (Route<dynamic> route) => false);
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }

//  void signIn() async {
//    if (_formKey.currentState.validate()) {
//      _formKey.currentState.save();
//
//      print("email: $_email, password: $_password");
//    }
//  }
  void signIn() async {
    dynamic result = await _auth.signInAnon();
    if(result == null) {
      print('Error Sign in');
    } else {
      print('login successfull!');
      print(result.uid);
    }
    //Navigator.of(context).pushNamedAndRemoveUntil('/teacher_dashboard', (Route<dynamic> route) => false);
  }

}
