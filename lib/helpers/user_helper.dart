import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "userTable";
final String idColumn = "id";
final String nameColumn = "name";
final String emailColumn = "email";
final String phoneColumn = "phone";
final String imgColumn = "profileUrl";

class UserHelper {
  static final UserHelper _instance = UserHelper.internal();

  factory UserHelper() => _instance;
  UserHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "bordero.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $tableName ( "
          "$idColumn INTEGER PRIMARY KEY, "
          "$nameColumn TEXT, "
          "$emailColumn TEXT,"
          "$phoneColumn TEXT, "
          "$imgColumn TEXT)");
    });
  }

  Future<User> saveUser(User user) async {
    Database dbUser = await db;
    user.id = await dbUser.insert(tableName, user.toMap());
    return user;
  }

  Future<User> getUser(int id) async {
    Database dbUser = await db;
    List<Map> maps = await dbUser.query(tableName,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteUser(int id) async {
    Database dbUser = await db;
    return await dbUser
        .delete(tableName, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    Database dbUser = await db;
    return await dbUser.update(tableName, user.toMap(),
        where: "$idColumn = ?", whereArgs: [user.id]);
  }

  Future<List> getAllUsers() async {
    Database dbUser = await db;
    List listMap = await dbUser.rawQuery("SELECT * FROM $tableName");
    List<User> listUser = List();
    for (Map m in listMap) {
      listUser.add(User.fromMap(m));
    }
    return listUser;
  }

  Future<User> getFirst() async{
    try {
      var allUsers = await getAllUsers();
      return allUsers.first;
    }catch(ex){
      return null;
    }
  }

  Future<int> getNumber() async {
    Database dbUser = await db;
    return Sqflite.firstIntValue(
        await dbUser.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future close() async {
    Database dbUser = await db;
    dbUser.close();
  }
}

class User {
  int id;
  String name;
  String email;
  String phone;
  String urlProfile;

  User();

  User.fromName(this.name);

  User.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    urlProfile = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: urlProfile
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Usuário: (id: $id, name: $name, email: $email, phone: $phone, img: $urlProfile)";
  }
}
