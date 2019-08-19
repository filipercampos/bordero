import 'package:flutter/material.dart';

import '../models/client.dart';
import '../repository/repository_helper.dart';

class ClientDataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    //botão limpar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icone animado
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_)=> close(context, query));

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder<List<Client>>(
        future: suggestions(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data[index].name),
                  leading: Icon(Icons.account_box),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                );
              },
              itemCount: snapshot.data.length,
            );
          }
        },
      );
    }
  }

  Future<List<Client>> suggestions(String search) async {
    final helper = RepositoryHelper().clientRepository;
    List<Client> clients = List();
    await helper.rawQueryMap({"name": search}, like: true).then((list) {
      list.forEach((map) => clients.add(Client.fromJson(map)));
    });
    return clients;
  }
}
