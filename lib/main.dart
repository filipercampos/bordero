import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/screens/home_screen.dart';
import 'package:bordero/screens/signup/signup_screen.dart';
import 'package:bordero/themes/theme_default.dart';
import 'package:bordero/util/color_util.dart';
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
      child: StreamBuilder<bool>(
        stream: _userBloc.outRegister,
        builder: (context, snapshot) {
          return StreamBuilder<bool>(
            stream: _userBloc.outLoading,
            initialData: false,
            builder: (context, snapshotLoading) {
              if (!snapshot.hasData || snapshotLoading.data) {
                return Container(
                  color: HexColor('#00a6bf'),
                  height: 100.0,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              }
              return MaterialApp(
                title: 'Borderô',
                theme: ThemeDefault().themeDefault(),
                home: Scaffold(
                  body:  _userBloc.isRegister() ? HomeScreen() : SignUpScreen(),
                ),
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }


}
