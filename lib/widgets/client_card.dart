import 'package:bordero/models/client.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/screens/client_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientCard extends StatelessWidget {
  final Client client;

  ClientCard(this.client);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    client.name ?? "",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    client.phone1 ?? "Celular não Informado",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    client.email ?? "Email não informado",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showEditClientSceen(context, client);
      },
      onLongPress: () {
        _showOptions(context);
      },
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(Icons.phone),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Ligar",  style: TextStyle(color: Colors.black),),
                          ],
                        ),
                        onPressed: () {
                          launch("tel:${client.phone1}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(Icons.edit),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Editar",  style: TextStyle(color: Colors.black),),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showEditClientSceen(context, client);
                        },
                      ),
                    ),
//                    Padding(
//                      padding: EdgeInsets.all(10.0),
//                      child: FlatButton(
//                        child: Text("Excluir",
//                          style: TextStyle(color: Colors.red, fontSize: 20.0),
//                        ),
//                        onPressed: (){
//                          helper.delete(client.id);
//                          setState(() {
//                            clients.removeAt(index);
//                            Navigator.pop(context);
//                          });
//                        },
//                      ),
//                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showEditClientSceen(context, Client client) async {
    final Client recClient = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ClientScreen(client: client)));
    final helper = RepositoryHelper().clientRepository;
    if (recClient != null) {
      await helper.update(recClient.toJson());
    }
  }
}
