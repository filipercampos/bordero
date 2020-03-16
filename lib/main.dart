import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/screens/login/login_screen.dart';
import 'package:bordero/themes/theme_default.dart';
import 'package:flutter/material.dart';

import 'blocs/user_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _userBloc = UserBloc();
    return BlocProvider(
      blocs: [
        Bloc((i) => _userBloc),
      ],
      child: MaterialApp(
        title: 'Borderô',
        theme: ThemeDefault().themeDefault(),
        home: Scaffold(
          body: LoginScreen(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
