import 'package:bordero/screens/bordero_screen.dart';
import 'package:bordero/tabs/cheques_tab.dart';
import 'package:bordero/tabs/client_tab.dart';
import 'package:bordero/widgets/bordero_button.dart';
import 'package:bordero/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {

    return PageView(
      //cancela o desliza entre as paginas
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("Menu"),
          ),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: BorderoButton(_pageController),
        ),
        ///Tela de cálculo
        BorderoScreen(_pageController),
        Scaffold(
          appBar: AppBar(
            title: Text("Cheques"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ChequesPage(),
        )  ,
        ClientsTab(_pageController),

      ],
    );
  }
}
