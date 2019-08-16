import 'package:bordero/enums/order_options.dart';
import 'package:bordero/models/client.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/screens/client_screen.dart';
import 'package:bordero/widgets/client_card.dart';
import 'package:bordero/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class ClientsTab extends StatefulWidget {
  final PageController _controller;

  ClientsTab(this._controller);

  @override
  _ClientsTabState createState() => _ClientsTabState();
}

class _ClientsTabState extends State<ClientsTab> {
  final helper = RepositoryHelper().clientRepository;

  List<Client> clients = List();

  @override
  void initState() {
    super.initState();

    _getAllClients();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes"),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.ASC,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.DESC,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      drawer: CustomDrawer(widget._controller),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddClientPage();
        },
        child: Icon(Icons.add),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            print(clients[index].toString());
            return ClientCard(clients[index]);
          }),
    );
  }

  void _showAddClientPage() async {
    final Client recClient = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientScreen(),
      ),
    );
    if (recClient != null) {
      await helper.insert(recClient.toJson());
      _getAllClients();
    }
  }

  void _getAllClients() {
    clients.clear();
    helper.getAll().then((list) {
      setState(() {
        list.forEach((map) => clients.add(Client.fromJson(map)));
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.ASC:
        clients.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.DESC:
        clients.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
