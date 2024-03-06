import 'package:flutter/material.dart';
import 'package:flutter_app_contacts/pages/home.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
      primarySwatch: Colors.blue,

      textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.blue
      ),
  ),
  home: Home(),
));
