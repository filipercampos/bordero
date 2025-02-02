import 'package:bordero/util/color_util.dart';
import 'package:flutter/material.dart';

class ThemeDefault {
  //Singleton
  ThemeDefault._internal();

  static final ThemeDefault _instance = ThemeDefault._internal();

  factory ThemeDefault() => _instance;

  Color primaryColor = HexColor('#00a6bf'); //ITE color

  themeDefault() {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      appBarTheme: AppBarTheme(
        color: primaryColor,
        textTheme: TextTheme(
          headline6: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
          caption: TextStyle(color: Colors.white, fontSize: 14.0),
          bodyText2: TextStyle(color: Colors.white, fontSize: 14.0),
        ),
      ),
    );
  }
}
