import 'package:bordero/helpers/user_helper.dart';
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
  User _user;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    //listener da animação e login
    _animationController.addStatusListener((status) {
      print("Animaton State $status");
      if (status == AnimationStatus.completed) {
        _onSuccess();
      }
    });
    _loadUser();
  }

  void _loadUser() async {
    print("Dados do usuário carregados");
    _user = await UserHelper.internal().getFirst();

    print(_user.toString());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        color: Colors.teal,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Nome de Exibição",
                        labelText: "Nome",
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: (text) {
                        if (text.isEmpty || text.length < 4) {
                          return "Informe um nome e sobrenome";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Ação de de login animado
          Container(
            margin: EdgeInsets.only(bottom: 100),
            child: StaggerAnimation(
              controller: _animationController.view,
              scaffoldKey: _scaffoldKey,
              user: _user,
            ),
          ),
        ],
      ),
    );
  }

  ///Chama a HomeScreen
  void _onSuccess() {
    print("Logon on firebase ...");

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
