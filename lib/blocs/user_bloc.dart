import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/enums/app_state.dart';
import 'package:bordero/models/user.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/util/string_util.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase with UserValidator {
  final _nameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _userController = BehaviorSubject<User>();
  final _registerController = BehaviorSubject<bool>();
  final _loadingController = BehaviorSubject<bool>();
  final _loginStateController = BehaviorSubject<AppState>();
  
  Stream<bool> get outRegister => _registerController.stream;

  Stream<String> get outName => _nameController.stream.transform(validateName);

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);

  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get outLoading => _loadingController.stream;

  Function(String) get changeName => _nameController.sink.add;

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  Stream<User> get outUser => _userController.stream;

  Stream<bool> get outSubmitValid =>
      Observable.combineLatest2(outEmail, outPassword, (user, email) => true);

  Stream<AppState> get outLoginState => _loginStateController.stream;

  final _userRepository = RepositoryHelper().userRepository;

  UserBloc() {
    //nao tera autenticação por enquanto
    _passwordController.add("default");
    _loadUser();
    _registerController.add(false);
  }

  Future<void> _loadUser() async {
    print("Carregando dados do usuário ...");
    _loadingController.add(true);
    final userMap = await _userRepository.getFirst();
    if (userMap != null) {
      _userController.add(User.fromJson(userMap));
      _registerController.add(true);
      print("Data user loaded !");
    } else {
      _registerController.add(false);
    }
    _loadingController.add(false);
  }

  bool isRegister() {
    return _userController.hasValue;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.close();
    _emailController.close();
    _passwordController.close();
    _registerController.close();
    _loadingController.close();
    _loginStateController.close();
  }

  /// Register user on system
  Future<bool> submit() async {
    final name = _nameController.value;
    final email = _emailController.value;
    final password =
        StringUtil.hashSha1(_passwordController.value); // data being hashed

    final user = User.register(
      name: name,
      email: email,
      password: password,
    );
    int id = await _userRepository.insert(user.toJson());
    if (id != 0) {
      _userController.add(user);
      _registerController.add(true);
    }
    _registerController.add(false);
    return id > 0;
  }

  void updateUser(User user) async {
    final userMap = user.toJson();
    userMap.remove("password");

    int id = await _userRepository.update(userMap);
    if (id != 0) {
      _userController.add(user);
    }
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

  //Transforma string em Stream
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length > 3) {
        sink.add(password);
      } else {
        sink.addError("Insira uma senha 4 dígitos");
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
