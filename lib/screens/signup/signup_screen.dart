import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/blocs/user_bloc.dart';
import 'package:bordero/screens/home_screen.dart';
import 'package:bordero/screens/signup/widgets/stagger_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  //controlador da animação
  AnimationController _animationController;

  //key para snack bar
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    //listener da animação e login
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onSuccess();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.getBloc<UserBloc>();
    timeDilation = 1;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 100, bottom: 16),
                    child: Image.asset(
                      "icons/bordero.png",
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    "Bem-vindo ao Borderô",
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        StreamBuilder<String>(
                            stream: _userBloc.outName,
                            builder: (context, snapshot) {
                              return TextField(
                                maxLength: 50,
                                controller: _nameController,
                                onChanged: _userBloc.changeName,
                                decoration: InputDecoration(
                                  hintText: "Nome",
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                              );
                            }),
                        StreamBuilder<String>(
                            stream: _userBloc.outEmail,
                            builder: (context, snapshot) {
                              return TextField(
                                maxLength: 100,
                                controller: _emailController,
                                onChanged: _userBloc.changeEmail,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                              );
                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Ação de de login animado
                  Container(
                    child: StaggerAnimation(
                      controller: _animationController.view,
                      scaffoldKey: _scaffoldKey,
                      userName: _nameController.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Chama a HomeScreen
  void _onSuccess() {
    print("Logon on Borderô ...");
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => HomeScreen(),
    ));
  }

  ///Para a animação
  void _onFail() {
    _animationController.reset();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Informe seu nome para continuar"),
      backgroundColor: Colors.redAccent,
    ));
  }
}
