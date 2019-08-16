import 'package:bordero/repository/migration_repository.dart';

class ClientMigration implements MigrationRepository {
  
  @override
  String tableName() {
    return 'client';
  }
  
  @override
  String alterTable() {
    final ddl = "DROP TABLE client";
    return ddl;
  }

}
