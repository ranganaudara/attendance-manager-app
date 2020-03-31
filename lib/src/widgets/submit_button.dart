import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  SubmitButton({this.onSubmit, this.title});
  final VoidCallback onSubmit;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(32.0),
        color: Theme.of(context).primaryColor,
        shadowColor: Colors.blueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 150.0,
          height: 45.0,
          onPressed: onSubmit,
          child: Text(title),
        ),
      ),
    );
  }
}
