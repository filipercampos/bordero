import 'package:bordero/models/client.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/widgets/client_card.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AppBarSearch extends StatefulWidget {
  AppBarSearch();

  @override
  _AppBarSearchState createState() => _AppBarSearchState();
}

class _AppBarSearchState extends State<AppBarSearch>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  TextEditingController _searchQuery;
  bool _isSearching = false;
  List<Client> allRecord = List<Client>();
  List<Client> filteredRecored =List<Client>();
  final helper = RepositoryHelper().clientRepository;
  @override
  void initState() {
    super.initState();
    _searchQuery = TextEditingController();
    _getAllClients();
  }

  void _getAllClients() async {
    allRecord = await helper.all();

    setState(()  {
    });
    filteredRecored = List<Client>();
    filteredRecored.addAll(allRecord);
  }



  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
      filteredRecored.addAll(allRecord);
    });
  }

  void _clearSearchQuery() {
    setState(() {
      print("clear search");
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            Text(
              'Clientes',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

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
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String Query) {
    filteredRecored.clear();
    if (Query.length > 0) {
      Set<Client> set = Set.from(allRecord);
      set.forEach((element) => filterList(element, Query));
    }

    if (Query.isEmpty) {
      filteredRecored.addAll(allRecord);
    }

    setState(() {});
  }

  filterList(Client country, String searchQuery) {
    setState(() {
      if (country.name.toLowerCase().contains(searchQuery) ||
          country.name.contains(searchQuery)) {
        filteredRecored.add(country);
      }
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              print("pop search");
              return;
            }
            //_clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: _startSearch,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: _isSearching
            ? BackButton(
                color: Colors.white,
              )
            : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
      ),
      body: filteredRecored != null && filteredRecored.length > 0
          ? ListView.builder(
              itemCount: filteredRecored.length,
              itemBuilder: (context, index) {
                return ClientCard(filteredRecored[index]);
              },
            )
          : allRecord == null
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Text("Nenhum resultado"),
                ),
    );
  }
}
