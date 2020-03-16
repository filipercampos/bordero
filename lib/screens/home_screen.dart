import 'package:bordero/screens/bordero_screen.dart';
import 'package:bordero/screens/tabs/cheques_tab.dart';
import 'package:bordero/screens/tabs/clients_tab.dart';
import 'package:bordero/screens/widgets/bordero_button.dart';
import 'package:bordero/screens/widgets/custom_drawer.dart';
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
        //Tela de cálculo
        BorderoScreen(_pageController),
        //Cheques salvos
        ChequesTab(_pageController),
        //Clientes
        ClientsTab(_pageController),
      ],
    );
  }
}
