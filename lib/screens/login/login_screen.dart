import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/blocs/user_bloc.dart';
import 'package:bordero/enums/app_state.dart';
import 'package:bordero/screens/home_screen.dart';
import 'package:bordero/screens/login/stagger_animation_signup.dart';
import 'package:bordero/util/animation_util.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

    final _userBloc = BlocProvider.getBloc<UserBloc>();

  //controlador da animação
  AnimationController _animationController;

  //key para snack bar
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

//  final _passwordController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );

    //listener da animação e login
    _animationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed && _userBloc.userData != null ) {
           _onSuccess();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _emailFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: StreamBuilder<AppState>(
          stream: _userBloc.outLoginState,
          builder: (context, snapshot) {
            if (snapshot.data == AppState.LOADING) {
              return Container(
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: AnimationUtil.circularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,),
                ),
              );
            }
            else if (snapshot.data == AppState.FAIL) {
              _animationController.reset();
            }
            else if (snapshot.data == AppState.SUCCESS) {
              _animationController.forward();
              FocusScope.of(context).unfocus();
            }
            return ListView(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 100, bottom: 16),
                          child: Image.asset(
                            "assets/icons/bordero.png",
                            width: 120.0,
                            height: 120.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          //center
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "Bem-vindo ao Borderô",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                child: StreamBuilder<String>(
                                  stream: _userBloc.outName,
                                  builder: (context, snapshot) {
                                    return TextField(
                                      autofocus: true,
                                      maxLength: 30,
                                      controller: _nameController,
                                      onChanged: _userBloc.changeName,
                                      decoration: InputDecoration(
                                        hintText: "Nome",
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null,
                                      ),
                                      keyboardType: TextInputType.text,
                                      focusNode: _nameFocus,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (term) {
                                        _nameFocus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_emailFocus);
                                      },
                                    );
                                  },
                                ),
                              ),
                              Container(
                                child: StreamBuilder<String>(
                                  stream: _userBloc.outEmail,
                                  builder: (context, snapshot) {
                                    return TextField(
                                      autofocus: true,
                                      focusNode: _emailFocus,
                                      maxLength: 100,
                                      controller: _emailController,
                                      onChanged: _userBloc.changeEmail,
                                      decoration: InputDecoration(
                                        hintText: "Email",
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.done,
                                    );
                                  },
                                ),
                              ),
//                        //Nao tera autenticacao por enquanto
//                        StreamBuilder<String>(
//                          stream: _userBloc.outPassword,
//                          builder: (context, snapshot) {
//                            return TextField(
//                              autofocus: true,
//                              maxLength: 4,
//                              obscureText: true,
//                              controller: _passwordController,
//                              onChanged: _userBloc.changePassword,
//                              decoration: InputDecoration(
//                                hintText: "Senha",
//                                errorText:
//                                snapshot.hasError ? snapshot.error : null,
//                              ),
//                              keyboardType: TextInputType.number,
//                              textInputAction: TextInputAction.done,
//                            );
//                          },
//                        ),
                            ],
                          ),
                        ),
                        Container(
                          height: 120,
                        ),
                      ],
                    ),

                    //Ação de de login animado
                    StaggerAnimationSignUp(
                      controller: _animationController.view,
                      scaffoldKey: _scaffoldKey,
                      snapshot: snapshot,
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  ///Chama a HomeScreen
  void _onSuccess() async {
    print("Logon on Borderô ...");
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => HomeScreen(),
    ));
  }
}
