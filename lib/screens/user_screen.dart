import 'dart:async';
import 'dart:io';

import 'package:bordero/helpers/user_helper.dart';
import 'package:bordero/widgets/image_source_sheet.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  final User contact;

  UserScreen({this.contact});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  User _editedUser;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedUser = User();
    } else {
      _editedUser = User.fromMap(widget.contact.toMap());

      _nameController.text = _editedUser.name;
      _emailController.text = _editedUser.email;
      _phoneController.text = _editedUser.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(_editedUser.name ?? "Meus Dados"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedUser.name != null && _editedUser.name.isNotEmpty) {
              Navigator.pop(context, _editedUser);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedUser.urlProfile != null
                            ? FileImage(File(_editedUser.urlProfile))
                            : AssetImage("images/avatar.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => ImageSourceSheet(
                            onImageSelected: (image) {
                              if (image != null) {
                                setState(() {
                                  _editedUser.urlProfile = image.path;
                                });
                                Navigator.of(context).pop();
                              }
                            },
                          ));

                  ///imagem da camera
//                  ImagePicker.pickImage(source: ImageSource.camera).then((
//                      file) {
//                    if (file == null) return;
//                    setState(() {
//                      _editedUser.urlProfile = file.path;
//                    });
//                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedUser.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedUser.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedUser.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
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
}
