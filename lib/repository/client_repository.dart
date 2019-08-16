import 'package:bordero/repository/repository.dart';

class ClientRepository extends Repository  {
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

}
