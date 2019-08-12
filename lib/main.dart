import 'package:bordero/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Borderô',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.teal// Color.fromARGB(255, 4, 125, 141),
      ),
      home: SignUpScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}