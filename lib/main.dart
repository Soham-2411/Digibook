import 'package:digibook/Navbar.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
        theme: ThemeData(fontFamily: 'Montserrat', primaryColor: Colors.white),
        home: NavBar()),
  );
}
