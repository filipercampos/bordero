import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/helpers/user_helper.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase with UserValidator {
  final _nameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _userController = BehaviorSubject<User>();

  Stream<String> get outName => _nameController.stream.transform(validateName);

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);

  Function(String) get changeName => _nameController.sink.add;

  Function(String) get changeEmail => _emailController.sink.add;

  Stream<User> get outUser => _userController.stream;

  Stream<bool> get outSubmitValid =>
      Observable.combineLatest2(outName, outEmail, (user, email) => true);

  UserBloc() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    print("Carregando dados do usuário ...");
    final user = await UserHelper.internal().getFirst();
    _userController.add(user);
  }

  bool isRegister() {
    return _userController.hasValue;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.close();
    _emailController.close();
  }

  void saveUser(User user) {
    UserHelper.internal().updateUser(user);
    _userController.add(user);
  }
}

class UserValidator {
  //Transforma string em Stream
  final validateName = StreamTransformer<String, String>.fromHandlers(
    handleData: (name, sink) {
      if (name.isNotEmpty && name.length > 4) {
        sink.add(name);
      } else {
        sink.addError("Insira um nome completo para exibição");
      }
    },
  );

  //Transforma string em Stream
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (_validateEmail(email)) {
        sink.add(email);
      } else {
        sink.addError("Insira um e-mail válido");
      }
    },
  );

  static _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }
}
