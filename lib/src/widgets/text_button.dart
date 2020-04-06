import 'package:flutter/material.dart';

class TextButton extends StatelessWidget {

  TextButton({this.title, this.onSubmit});
  final String title;
  final VoidCallback onSubmit;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 5),
      textColor: Theme.of(context).primaryColor,
      disabledTextColor: Theme.of(context).disabledColor,
      splashColor: Theme.of(context).accentColor,
      onPressed: onSubmit,
      child: Text(
        title,
        style: TextStyle(fontSize: 15),
      )
    );
  }
}
