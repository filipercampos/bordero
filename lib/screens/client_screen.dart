import 'dart:async';

import 'package:bordero/models/client.dart';
import 'package:bordero/repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

///Insere ou atualiza um cliente
class ClientScreen extends StatefulWidget {
  final Client client;

  ClientScreen({this.client});

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfCnpjController = MaskedTextController(mask: '000.000.000-00');
  final _phoneController1 = MaskedTextController(mask: '(00) 00000-0000');
  final _phoneController2 = MaskedTextController(mask: '(00) 00000-0000');
  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Client _editedClient;
  final ClientRepository _clientRepository = ClientRepository();

  @override
  void initState() {
    super.initState();

    if (widget.client == null) {
      _editedClient = Client();
    } else {
      _editedClient = widget.client;

      _nameController.text = _editedClient.name;
      _emailController.text = _editedClient.email;
      _phoneController1.text = _editedClient.phone1;
      _phoneController2.text = _editedClient.phone2;
      _cpfCnpjController.text = _editedClient.cpfCnpj;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(_editedClient.name ?? "Novo Cliente"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedClient.name != null && _editedClient.name.isNotEmpty) {
              Navigator.pop(context, _editedClient);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage("images/avatar.png"),
                      fit: BoxFit.cover),
                ),
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedClient.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedClient.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController1,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedClient.phone1 = text;
                },
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _phoneController2,
                decoration: InputDecoration(labelText: "Phone (Alternativo)"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedClient.phone2 = text;
                },
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _cpfCnpjController,
                decoration: InputDecoration(labelText: "CPF/CNPJ"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedClient.email = text;
                },
                keyboardType: TextInputType.number
              ),
              SizedBox(height: 20,),
              SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (v) {
                    _editedClient.classificacao = v;
                    setState(() {});
                  },
                  starCount: 5,
                  rating: _editedClient.classificacao,
                  size: 60.0,
                  color: Colors.yellow[700],
                  borderColor: Colors.yellow[700],
                  spacing: 0.0)
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
