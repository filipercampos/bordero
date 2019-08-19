import 'dart:async';

import 'package:bordero/repository/cheque_repository.dart';
import 'package:bordero/repository/migration_repository.dart';
import 'package:bordero/repository/user_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'client_repository.dart';

class RepositoryHelper {
  int version = 1;
  static final RepositoryHelper _instance = RepositoryHelper._internal();

  factory RepositoryHelper() => _instance;

  RepositoryHelper._internal() {
    print("Internal call");
    initDatabase();
  }

  final UserRepository userRepository = UserRepository();
  final ClientRepository clientRepository = ClientRepository();
  final ChequeRepository chequeRepository = ChequeRepository();
  List<MigrationRepository> _migrations = List();

  ///Cria a tabela com uma pk do tipo inteiro => id
  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "bordero.db");
    var alterTable = this._migrations.length > 0;
    if (alterTable) {
      version++;
    }
    print("Initialize database version $version ...");

    var db = await openDatabase(
      path,
      version: version,
      onCreate: _onCreate,
      onUpgrade: alterTable ? _onUpgrade : null,
    );

//     deleteDatabase(path);
//     File(path).delete();
//     print("Delete => ${File(path).exists().toString()}");

    return db;
  }

  void _onCreate(Database db, int newerVersion) async {
    print("Building database ...");
    String ddl1 = userRepository.ddlTable();
    String ddl2 = clientRepository.ddlTable();
    String ddl3 = chequeRepository.ddlTable();

    await db.execute(ddl1);
    await db.execute(ddl2);
    await db.execute(ddl3);
  }

  ///Update tables
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      for (var migration in _migrations) {
        db.execute(migration.alterTable());
        print("alter table => ${migration.tableName()}");
        print(migration.alterTable());
      }
      _migrations.clear();
    }
  }

  void setUpmigration(MigrationRepository  migration) {
    this._migrations.add(migration);
  }
}
