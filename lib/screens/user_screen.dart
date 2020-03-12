import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/blocs/user_bloc.dart';
import 'package:bordero/models/user.dart';
import 'package:bordero/widgets/image_source_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class UserScreen extends StatefulWidget {
  final User user;

  UserScreen({this.user});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '(00) 00000-0000');

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  User _editedUser;

  @override
  void initState() {
    super.initState();

    if (widget.user == null) {
      _editedUser = User();
    } else {
      _editedUser = widget.user;

      _nameController.text = _editedUser.name;
      _emailController.text = _editedUser.email;
      _phoneController.text = _editedUser.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final _userBloc = BlocProvider.getBloc<UserBloc>();
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(_editedUser.name ?? "Meus Dados"),
          centerTitle: true,
        ),
        floatingActionButton: StreamBuilder<User>(
            stream: _userBloc.outUser,
            builder: (context, snapshot) {
              return FloatingActionButton(
                onPressed: () {
                  if (_editedUser.name != null && _editedUser.name.isNotEmpty) {
                    _userBloc.updateUser(_editedUser);
                    Navigator.pop(context, _editedUser);
                  } else {
                    FocusScope.of(context).requestFocus(_nameFocus);
                  }
                },
                child: Icon(Icons.save),
                backgroundColor: primaryColor,
              );
            }),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: _buildAvatar(),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => ImageSourceSheet(
                      onImageSelected: (image) {
                        if (image != null) {
                          setState(() {
                            _editedUser.profileUrl = image.path;
                          });
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  );
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  labelText: "Nome",
                  icon: Icon(Icons.account_circle, color: primaryColor),
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedUser.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  icon: Icon(
                    Icons.email,
                    color: primaryColor,
                  ),
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedUser.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                  icon: Icon(Icons.phone, color: primaryColor),
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedUser.phone = text
                      .replaceAll("(", "")
                      .replaceAll(")", "")
                      .replaceAll(" ", "")
                      .replaceAll("-", "");
                },
                keyboardType: TextInputType.phone,
              ),
//               TextField(
//                controller: _phoneController,
//                obscureText: true,
//                readOnly: true,
//                decoration: InputDecoration(
//                  labelText: "Senha",
//                  icon: Icon(Icons.lock, color: primaryColor),
//                ),
//                onChanged: (text) {
//                  _userEdited = true;
//                  _editedUser.password = text;
//                },
//                keyboardType: TextInputType.phone,
//              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  _buildAvatar() {
    if (_editedUser.profileUrl != null) {
      return Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: FileImage(File(_editedUser.profileUrl)),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
        width: 140.0,
        height: 140.0,
        child: Icon(
          Icons.face,
          size: 72,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
  }
}
