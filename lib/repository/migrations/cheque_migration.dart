import 'package:bordero/repository/migration_repository.dart';

class ChequeMigration implements MigrationRepository {

  @override
  String tableName() {
    return 'cheque';
  }

  @override
  String alterTable() {
    final ddl = "ALTER TABLE cheque ADD COLUMN imagePath TEXT";
    return ddl;
  }

}
