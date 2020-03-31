import 'package:attendancemanagerapp/config/size_config.dart';
import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  SquareButton({this.title, this.icon, this.onPressed});

  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Container(
      height: SizeConfig.screenWidth*0.5,
      width: SizeConfig.screenWidth*0.5,
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          splashColor: Theme.of(context).accentColor,
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon,size: 100,),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
