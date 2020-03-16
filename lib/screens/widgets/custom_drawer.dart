import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/blocs/user_bloc.dart';
import 'package:bordero/models/user.dart';
import 'package:bordero/screens/user_screen.dart';
import 'package:bordero/screens/tiles/bordero_tile.dart';
import 'package:bordero/screens/tiles/cheques_tile.dart';
import 'package:bordero/screens/tiles/client_tile.dart';
import 'package:bordero/screens/tiles/home_tile.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final PageController _pageController;

  CustomDrawer(this._pageController);

  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.getBloc<UserBloc>();
    int _pages = 0;
    //degradê
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              // Theme.of(context).primaryColor,
              Color.fromARGB(150, 203, 234, 255),
              Colors.white,
            ], begin: Alignment.topCenter, end: Alignment.bottomRight),
          ),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(top: 16),
            children: <Widget>[
              StreamBuilder<User>(
                stream: _userBloc.outUser,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor
                        ),
                      ),
                    );
                  }
                  final user = snapshot.data;
                  return UserAccountsDrawerHeader(
                    accountName: Text(user.name ?? "Convidado"),
                    accountEmail: Text(user.email ?? "Termine seu cadastro"),
                    currentAccountPicture: GestureDetector(
                      onLongPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserScreen(
                              user: user,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: user.profileUrl != null
                            ? FileImage(File(user.profileUrl))
                            : AssetImage("assets/images/avatar.png"),
                        //https://gicons.carlosjeurissen.com/product-material/
                        // backgroundImage: NetworkImage('https://ssl.gstatic.com/images/branding/product/1x/avatar_circle_grey_512dp.png'),
                      ),
                    ),
                  );
                }
              ),
              HomeTile(_pageController, _pages++),
              BorderoTile(_pageController, _pages++),
              ChequesTile(_pageController, _pages++),
              ClientTile(_pageController, _pages++),
            ],
          ),
        ],
      ),
    );
  }
}
