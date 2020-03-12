import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/blocs/user_bloc.dart';
import 'package:flutter/material.dart';

/// Animação da tela de SignUp
class StaggerAnimationSignUp extends StatelessWidget {
  //scaffold key para snack bar
  final GlobalKey<ScaffoldState> scaffoldKey;

  //Controle da animação
  final AnimationController controller;
  final Animation<double> buttonSqueeze;
  final Animation<double> buttonZoomOut;

  StaggerAnimationSignUp({
    this.controller,
    @required this.scaffoldKey,
  })  
  //define o tamanho inicial e final do botão
  : buttonSqueeze = Tween(begin: 300.0, end: 60.0).animate(
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
    final _userBloc = BlocProvider.getBloc<UserBloc>();
    if (!await _userBloc.submit()) {
      _onFail();
    }
  }

  ///Para a animação
  void _onFail() {
    controller.reset();
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao registrar usuário"),
      backgroundColor: Colors.redAccent,
    ));
  }

  /// Animação do login
  Widget _buildAnimation(BuildContext context, Widget child) {
    //cor do botão login e do container animado
    //Color.fromRGBO(247, 64, 106, 1.0),
    Color buttonColor = Theme.of(context).primaryColor;
    final _userBloc = BlocProvider.getBloc<UserBloc>();
    return   Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: StreamBuilder<bool>(
          stream: _userBloc.outSubmitValid,
          builder: (context, snapshot) {
            return InkWell(
              //ação de animar
              onTap: snapshot.hasData
                  ? () async {
                      //inicia a animação
                      controller.forward();
                      await saveData();
                    }
                  : null,
              //animação de encolher
              child: Hero(
                tag: "fade",
                child: buttonZoomOut.value == 60
                    //container padraõ do botão
                    ? Container(
                        margin: EdgeInsets.only(left: 5,right: 5),
                        width: buttonSqueeze.value,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: snapshot.hasData ? buttonColor : Colors.grey,
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
          },

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
            fontSize: 16,
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
