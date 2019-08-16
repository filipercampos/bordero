import 'package:bordero/repository/repository.dart';

class UserRepository extends Repository {
  UserRepository()
      : super(
          "user",
          {
            "name": "TEXT NOT NULL",
            "email": "TEXT NOT NULL",
            "password": "TEXT NOT NULL",
            "phone": "TEXT",
            "profileUrl": "TEXT",
          },
        );
}
