import 'package:attendancemanagerapp/config/size_config.dart';
import 'package:attendancemanagerapp/services/auth.dart';
import 'package:attendancemanagerapp/src/widgets/input_field.dart';
import 'package:attendancemanagerapp/src/widgets/loading.dart';
import 'package:attendancemanagerapp/src/widgets/logo_thumb.dart';
import 'package:attendancemanagerapp/src/widgets/submit_button.dart';
import 'package:attendancemanagerapp/src/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherLoginScreen extends StatefulWidget {
  @override
  _TeacherLoginScreenState createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  final AuthService _auth = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email, _password;
  final _passwordFieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: SizeConfig.screenHeight * 0.17),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                    Text(
                      "Don't have an Account?",
                      style: Theme.of(context).textTheme.body2,
                    ),
                    TextButton(
                      title: 'Register',
                      onSubmit: () {
                        Navigator.popAndPushNamed(context, '/teacher_register');
                      },
                    ),
                  ],
                ),
//                SizedBox(height: SizeConfig.blockSizeVertical),
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
            ),
          ),
        ),
      ),
    );
  }

  void invalidAuth(String msg) {
    setState(() {
      _showSnackBar(msg);
      _formKey.currentState.reset();
    });
  }

  _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.blueGrey,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  void signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Loading();
          });
      try {
        dynamic userData = await _auth.signInWithEmailAndPassword(
            _email, _password);
        if (userData == null) {
          Navigator.pop(context);
          invalidAuth('Error Sign in');
        } else if(userData.data['role'] != 'teacher'){
          Navigator.pop(context);
          invalidAuth("This email doesn't have a teacher's account");
        } else if(userData.data['role'] == 'teacher'){
          print('login successfull!');
          _savePreference(userData.data['uid']);
        } else {
          Navigator.pop(context);
          invalidAuth('Error Sign in');
        }
      }catch(err){
        Navigator.pop(context);
        print(err.message);
        invalidAuth(err.message);
      }
    }
  }

  _savePreference(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("teacherUid", uid);
    });
    Navigator.of(context).pop();
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/teacher_dashboard', (Route<dynamic> route) => false);
  }
}
