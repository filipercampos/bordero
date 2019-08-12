import 'package:bordero/helpers/user_helper.dart';
import 'package:bordero/screens/user_screen.dart';
import 'package:bordero/tiles/bordero_tile.dart';
import 'package:bordero/tiles/cheques_tile.dart';
import 'package:bordero/tiles/home_tile.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final PageController _pageController;
  User _user ;
  User get user => _user;

  CustomDrawer(this._pageController){

    _loadUser();
  }

  void _loadUser() async {
    print("Dados do usuário carregados");
    _user = await UserHelper.internal().getFirst();

    print(_user.toString());

  }

  @override
  Widget build(BuildContext context) {
    int _pages = 0;
    //degradê
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              // Color.fromARGB(255, 203, 236, 241),
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
              UserAccountsDrawerHeader(
                accountName: Text(user.name),
                accountEmail: Text(user.email??""),
                currentAccountPicture: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UserScreen()));
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage("images/avatar.png"),
                    //https://gicons.carlosjeurissen.com/product-material/
                    // backgroundImage: NetworkImage('https://ssl.gstatic.com/images/branding/product/1x/avatar_circle_grey_512dp.png'),
                  ),
                ),
              ),
              HomeTile(_pageController, _pages++),
              BorderoTile(_pageController, _pages++),
              ChequesTile(_pageController, _pages++),
            ],
          ),
        ],
      ),
    );
  }
}
