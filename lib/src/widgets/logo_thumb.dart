import 'package:flutter/material.dart';

class LogoThumb extends StatelessWidget {
  LogoThumb(this.imagePath);
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        child: Image(image: AssetImage(imagePath)),
        maxRadius: 60.0,
        minRadius: 20.0,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
