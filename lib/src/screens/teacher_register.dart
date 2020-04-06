import 'package:attendancemanagerapp/config/size_config.dart';
import 'package:attendancemanagerapp/services/auth.dart';
import 'package:attendancemanagerapp/src/mixins/validator_mixin.dart';
import 'package:attendancemanagerapp/src/widgets/input_field.dart';
import 'package:attendancemanagerapp/src/widgets/loading.dart';
import 'package:attendancemanagerapp/src/widgets/logo_thumb.dart';
import 'package:attendancemanagerapp/src/widgets/submit_button.dart';
import 'package:attendancemanagerapp/src/widgets/text_button.dart';
import 'package:flutter/material.dart';

class TeacherRegisterScreen extends StatefulWidget {
  @override
  _TeacherRegisterScreenState createState() => _TeacherRegisterScreenState();
}

class _TeacherRegisterScreenState extends State<TeacherRegisterScreen>
    with ValidatorMixin {
  final AuthService _auth = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _firstName, _lastName, _email, _subject, _password, err = '';
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
                SizedBox(height: SizeConfig.screenHeight * 0.1),
                LogoThumb('assets/images/teacher_login.png'),
                SizedBox(height: SizeConfig.blockSizeVertical * 3),
                Text(
                  'Teacher Registration',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextInputField(
                        isPassword: false,
                        labelText: 'First Name',
                        onSaved: (input) => _firstName = input,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter first name!';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeVertical * 3),
                    Expanded(
                      flex: 1,
                      child: TextInputField(
                        isPassword: false,
                        labelText: 'Last Name',
                        onSaved: (input) => _lastName = input,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 3),
                TextInputField(
                  isPassword: false,
                  labelText: 'Subject',
                  onSaved: (input) => _subject = input,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Subject cannot be empty!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 3),
                TextInputField(
                  isPassword: false,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (input) => _email = input,
                  validator: emailValidator,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 3),
                TextInputField(
                  isPassword: true,
                  fieldKey: _passwordFieldKey,
                  labelText: 'Password',
                  onSaved: (input) => _password = input,
                  validator: passwordValidator,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 3),
                SubmitButton(
                  title: 'Register',
                  onSubmit: signUp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                    Text(
                      "Already registered?",
                      style: Theme.of(context).textTheme.body2,
                    ),
                    TextButton(
                      title: 'Sign in',
                      onSubmit: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/teacher_login', (Route<dynamic> route) => false);
                      },
                    ),
                  ],
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

  void signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Loading();
          });
     try{
       dynamic result =
       await _auth.registerWithEmailAndPassword(_email, _password);
       if(result.user.uid == !null){
         Navigator.of(context).pushNamedAndRemoveUntil(
             '/teacher_dashboard', (Route<dynamic> route) => false);
       }else{
         Navigator.pop(context);
         invalidAuth("Something went wrong! Please try again!");
       }
     } catch(err){
       Navigator.pop(context);
       invalidAuth(err.message);
       print(err.message);
     }
    }
  }
}
