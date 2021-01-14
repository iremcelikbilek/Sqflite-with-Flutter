import 'package:flutter/material.dart';
import 'package:project_list_app/screens/home_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      //primaryColor: Colors.deepOrange,
        //accentColor: Colors.black
    ),
    home: HomePage(),
  ));
}

