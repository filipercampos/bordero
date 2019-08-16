import 'package:bordero/models/client.dart';
import 'package:bordero/repository/ilist.dart';
import 'package:bordero/repository/repository.dart';

class ClientRepository extends Repository implements IList  {
  ClientRepository()
      : super(
          "client",
           {
            "name": "TEXT NOT NULL",
            "email": "TEXT NULL",
            "cpfCnpj": "TEXT",
            "phone1": "TEXT",
            "phone2": "TEXT",
           "classificacao": "INTEGER",
          },
        );

  @override
  Future<Client> first() async {
    Client client;
    super.getFirst().then((map){
      client = Client.fromJson(map);
    });
    return client;
  }

  @override
  Future<List<Client>> all() async {
    List<Client> clients = List();
    await super.getAll().then((list) {

        list.forEach((map) => clients.add(Client.fromJson(map)));

    });
    return clients;
  }

}
