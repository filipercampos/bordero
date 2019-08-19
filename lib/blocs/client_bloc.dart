import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/enums/order_options.dart';
import 'package:bordero/models/client.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:rxdart/rxdart.dart';

class ClientBloc extends BlocBase {
  final _clientsController = BehaviorSubject<List<Client>>();
  Stream<List<Client>> get outClients => _clientsController.stream;

  //indica que começou a pesquisa
  final _searchingController = BehaviorSubject<String>();
  Sink get inSearch => _searchingController.sink;

  List<Client> _allClients = List<Client>();

  ClientBloc(){
    getAllClients();
    //realiza a pesquisa sempre que algo vier
    _searchingController.stream.listen(_search);
  }
  @override
  void dispose() {
    super.dispose();
    _clientsController.close();
    _searchingController.close();
  }

  Future<List<Client>> getAllClients() async {
    final helper = RepositoryHelper().clientRepository;
    final result = await helper.all();
    _allClients.addAll(result);
    _clientsController.add(result);
    helper.close();
    orderList(OrderOptions.ASC);
    return result;
  }

  void _search(String search) async {
    print("Searching client ...");
    if(search.trim().isEmpty){
      _clientsController.add(_allClients);
    }else{
      _clientsController.add(await filter(search.trim()));
    }
  }

  Future<List<Client>> filter(String search) async {
    List<Client> filteredClients= List.from( _allClients);
    filteredClients.retainWhere((client){
      return client.name.toLowerCase().contains(search.toLowerCase());
    });
    return filteredClients;
  }

  void orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.ASC:
        _allClients.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.DESC:
        _allClients.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    //notifica da ordenação
    _clientsController.add(_allClients);
  }
}
