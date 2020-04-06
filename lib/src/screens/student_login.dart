import 'package:attendancemanagerapp/config/size_config.dart';
import 'package:attendancemanagerapp/src/widgets/input_field.dart';
import 'package:attendancemanagerapp/src/widgets/logo_thumb.dart';
import 'package:attendancemanagerapp/src/widgets/submit_button.dart';
import 'package:attendancemanagerapp/src/widgets/text_button.dart';
import 'package:flutter/material.dart';

class StudentLoginScreen extends StatefulWidget {
  @override
  _StudentLoginScreenState createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
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
                  LogoThumb('assets/images/student_login.png'),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  Text(
                    'Sign in as Student',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 5),
                  TextInputField(
                    isPassword: false,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
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
                    'Are you a teacher?',
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

  void signIn() {
    Navigator.of(context).pushNamedAndRemoveUntil('/student_dashboard', (Route<dynamic> route) => false);
  }
}
