import 'package:flutter/material.dart';

InputDecoration _emailDecoration = InputDecoration(
  hintText: 'Email',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  fillColor: Colors.grey[200],
  filled: true,
  prefixIcon: Icon(
    Icons.mail,
    color: Colors.black,
  ),
);

InputDecoration _passwordDecoration = InputDecoration(
  hintText: 'Password',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  fillColor: Colors.grey[200],
  filled: true,
  prefixIcon: Icon(
    Icons.mail,
    color: Colors.black,
  ),
);
