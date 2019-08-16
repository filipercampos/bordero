import 'dart:async';

import 'package:bordero/repository/dao.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class Repository implements Dao {
  Database _database;
  final String tableName;
  final String _idColumn = "id";

  ///Map<Column name, Colum type>
  final Map<String, String> _columnsMap;

  Repository(this.tableName, this._columnsMap);


  Future<Database> get database async {
    if (_database != null && _database.isOpen == true) {
      return _database;
    } else {
      final RepositoryHelper _helper = RepositoryHelper();
      _database = await _helper.initDatabase();
      return _database;
    }
  }

  @override
  Future<int> insert(Map<String, dynamic> map) async {
    try {
      Database dbT = await database;
      return await dbT.transaction((txn) async {
        var batch = txn.batch();

        int id = await txn.insert(tableName, map);

        // commit but the actual commit will happen when the transaction is committed
        // however the data is available in this transaction
        await batch.commit();

        //pk table
        return id;
      });
    } catch (exception) {
      print("Insert $tableName failed => $exception.toString()");
      return 0;
    }
  }

  @override
  Future<int> update(Map map) async {
    try {
      Database dbT = await database;
      return await dbT.transaction((txn) async {
        var batch = txn.batch();

        int rowsAffected = await txn.update(tableName, map,
            where: "$_idColumn = ?", whereArgs: [map["id"]]);

        // commit but the actual commit will happen when the transaction is committed
        // however the data is available in this transaction
        await batch.commit();

        //rows affecteds
        return rowsAffected;
      });
    } catch (exception) {
      print("Insert $tableName failed => $exception.toString()");
      return 0;
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      Database dbT = await database;
      return await dbT.transaction((txn) async {
        var batch = txn.batch();

        int result = await txn
            .delete(tableName, where: "$_idColumn = ?", whereArgs: [id]);

        // commit but the actual commit will happen when the transaction is committed
        // however the data is available in this transaction
        await batch.commit();

        //rows affecteds
        return result > 0;
      });
    } catch (exception) {
      print("Insert $tableName failed => $exception.toString()");
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> get(int id) async {
    final columns = new List<String>();
    columns.add(_idColumn);
    _columnsMap.forEach((key, value) {
      columns.add(key);
    });

    Database dbT = await database;
    List<Map> maps = await dbT.query(tableName,
        //columns: columns,
        where: "$_idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return maps.first;
    } else {
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    Database dbT = await database;
    // List listMap = await dbT.rawQuery("SELECT * FROM $_tableName");
    List listMap = await dbT.query('$tableName');
    return listMap;
  }

  ///Executa um instruação do tipo DML
  Future<List<Map<String, dynamic>>> execute(String sqlFlite) async {
    Database dbT = await database;
    List listMap = await dbT.query(
      sqlFlite,
    );
    return listMap;
  }

  ///Executa um instrução do tipo DDL
  Future<void> executeNonQuery(String sqlFlite) async {
    Database dbT = await database;
    print("Executing non query .. ");
    print("=>$sqlFlite");
    await dbT.transaction((txn) async {
      // DON'T  use the database object in a transaction => (dbT)
      // this will deadlock!
      // Ok
      await txn.execute(sqlFlite);
    });
  }

  ///Top 1
  Future<Map> getFirst() async {
    try {
      var all = await getAll();
      return all.first;
    } catch (ex) {
      print("User not found => $ex");
      return null;
    }
  }

  ///Count element
  Future<int> count() async {
    Database dbT = await database;
    return Sqflite.firstIntValue(
        await dbT.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  ///Closed connection
  Future close() async {
    Database dbT = await database;
    dbT.close();
  }

  ///Cria a estrutura de tabela
  String ddlTable() {
    var ddl = StringBuffer();
    var keys = List<String>();

    //save keys for reference
    _columnsMap.forEach((key, value) {
      keys.add(key);
    });

    //generate ddl
    ddl.write("CREATE TABLE $tableName ( \n");
    ddl.write("$_idColumn INTEGER PRIMARY KEY,\n");

    for (int i = 0; i < keys.length; i++) {
      var key = keys[i];
      if (i == keys.length - 1) {
        //end build dml
        ddl.write("$key ${_columnsMap[key]}");
        ddl.write(")");
      } else {
        ddl.write("$key ${_columnsMap[key]},\n");
      }
    }
    return ddl.toString();
  }
}
