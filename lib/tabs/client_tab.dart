import 'package:bordero/blocs/client_bloc.dart';
import 'package:bordero/models/client.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/screens/client_screen.dart';
import 'package:bordero/widgets/client_card.dart';
import 'package:bordero/widgets/custom_drawer.dart';
import 'package:bordero/widgets/order_options_popup.dart';
import 'package:flutter/material.dart';

class ClientsTab extends StatefulWidget {
  final PageController _controller;

  ClientsTab(this._controller);

  @override
  _ClientsTabState createState() => _ClientsTabState();
}

class _ClientsTabState extends State<ClientsTab> {
  final helper = RepositoryHelper().clientRepository;
  final _clientBloc = ClientBloc();
  final clients = List<Client>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchQuery = TextEditingController();
  bool _isSearch = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Material(
      child: Scaffold(
        appBar: AppBar(
          leading: _isSearch ? BackButton(color: Colors.white) : null,
          title: _isSearch ? _buildSearchField() : Text("Clientes"),
          actions: _buildActions(),
          backgroundColor: primaryColor,
          centerTitle: true,
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
        body: StreamBuilder<List<Client>>(
            stream: _clientBloc.outClients,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                  ),
                );
              } else if (snapshot.data.length == 0) {
                return Center(
                    child: Text(
                      "Nenhum resultado",
                      style: TextStyle(color: Colors.grey),
                    ));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ClientCard(snapshot.data[index]);
                  },
                );
              }
            }),
      ),
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
      _clientBloc.getAllClients();
    }
  }

  /*Search bar*/

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Pesquisando ...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (search) {
        print(search);
        _clientBloc.inSearch.add(search);
      },
    );
  }

  List<Widget> _buildActions() {
    if (_isSearch) {
      return <Widget>[
        IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
          },
        ),
      ];
    }
    //barra padrão
    return <Widget>[
      IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () {
          //registra uma ação no widget
          //registra ação do back button and button clear
          ModalRoute.of(context).addLocalHistoryEntry(
            LocalHistoryEntry(
              onRemove: () {
                print("Close search bar");
                _searchQuery.clear();
                _clientBloc.inSearch.add("");
                setState(() {
                  _isSearch = false;
                });
              },
            ),
          );
          //nao dispara quando local entry é chamado
          setState(() {
            _isSearch = true;
          });
        },
      ),
      OrderOptionsPopup(_clientBloc.orderList)
    ];
  }
}
