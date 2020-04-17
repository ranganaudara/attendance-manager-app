import 'package:attendancemanagerapp/config/size_config.dart';
import 'package:attendancemanagerapp/services/auth.dart';
import 'package:attendancemanagerapp/src/mixins/validator_mixin.dart';
import 'package:attendancemanagerapp/src/widgets/input_field.dart';
import 'package:attendancemanagerapp/src/widgets/loading.dart';
import 'package:attendancemanagerapp/src/widgets/popup_message.dart';
import 'package:attendancemanagerapp/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen>
    with ValidatorMixin {
  final AuthService _auth = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _firstName, _lastName, _indexNum, _email, _subject, err = '', _uid;

  @override
  void initState() {
    _getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add new student'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
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
                  labelText: 'Index Number',
                  onSaved: (input) => _indexNum = input,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Index Number cannot be empty!';
                    }
                    return null;
                  },
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
                SubmitButton(
                  title: 'Register',
                  onSubmit: signUp,
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
      try {
        dynamic result = await _auth
            .registerStudent(
          firstName: _firstName,
          lastName: _lastName,
          indexNum: _indexNum,
          subject: _subject,
          password: _indexNum,
          email: _email,
          teacherUid: _uid,
        )
            .then((value) {
          if (value.user != null) {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PopupMessage(
                    message: "Successfully added!",
                    onSubmit: () {
                      Navigator.pop(context);
                      _formKey.currentState.reset();
                    },
                  );
                });
          } else {
            Navigator.pop(context);
            invalidAuth("Something went wrong! Please try again!");
          }
        });
      } catch (err) {
        Navigator.pop(context);
        invalidAuth(err.message);
        print(err.message);
      }
    }
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _uid = prefs.getString("teacherUid");
    });
    print(">>>>>>>>>>uid:"+_uid);
  }
}
