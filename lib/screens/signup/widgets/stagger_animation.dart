import 'package:bordero/helpers/user_helper.dart';
import 'package:flutter/material.dart';

/// Animação da tela de Login
class StaggerAnimation extends StatelessWidget {
  //scaffold key para snack bar
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User user;

  //Controle da animação
  final AnimationController controller;
  final Animation<double> buttonSqueeze;
  final Animation<double> buttonZoomOut;

  StaggerAnimation({
    this.controller,
    @required this.scaffoldKey,
    @required this.user,
  })  
  //define o tamanho inicial e final do botão
  : buttonSqueeze = Tween(begin: 320.0, end: 60.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.150), //porcentagem da animação
          ),
        ),
        buttonZoomOut = Tween(
          begin: 60.0, //tamanho inicial do botão
          end: 1000.0, //cubra a tela toda
        ).animate(
          //use uma curva que salte para cubrir a tela
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 1, curve: Curves.bounceOut),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }

  Future<Null> saveData() async {
    await UserHelper.internal().saveUser(user);
  }

  /// Animação do login
  Widget _buildAnimation(BuildContext context, Widget child) {
    //cor do botão login e do container animado
    //Color.fromRGBO(247, 64, 106, 1.0),
    Color buttonColor = Theme.of(context).primaryColor;
    return InkWell(
      //ação de animar
      onTap: () async {
        //inicia a animação
        controller.forward();
        //await saveData();
      },
      //animação de encolher
      child: Hero(
        tag: "fade",
        child: buttonZoomOut.value == 60
            //container do botão animado
            ? Container(
                width: buttonSqueeze.value,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                child: _buildInside(context),
              )
            //container que cresce e cobre a tela toda
            : Container(
                width: buttonZoomOut.value,
                height: buttonZoomOut.value,
                decoration: BoxDecoration(
                    color: buttonColor,
                    shape: buttonZoomOut.value < 500
                        ? BoxShape.circle
                        : BoxShape.rectangle),
              ),
      ),
    );
  }

  /// Botão de login ou circulo de progresso
  Widget _buildInside(BuildContext context) {
    //se o texto ainda cabe
    if (buttonSqueeze.value > 75) {
      return Text(
        "Começar",
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3),
      );
    }
    //desenhe um circulo
    else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 1.0,
      );
    }
  }
}
