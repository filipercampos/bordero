import 'package:bordero/dto/cheque_client.dart';
import 'package:bordero/models/cheque.dart';
import 'package:bordero/models/client.dart';
import 'package:bordero/repository/ilist.dart';
import 'package:bordero/repository/repository.dart';
import 'package:bordero/repository/repository_helper.dart';

class ChequeRepository extends Repository implements IList {
  ChequeRepository()
      : super(
          "cheque",
          {
            "dataEmissao": "INTEGER NOT NULL",
            "dataVencimento": "INTEGER NOT NULL",
            "dataPagamento": "INTEGER",
            "valorCheque": "REAL NOT NULL",
            "taxaJuros": "REAL NOT NULL",
            "valorJuros": "REAL NOT NULL",
            "valorLiquido": "REAL NOT NULL",
            "prazo": "      INTEGER NOT NULL",
            "compensacao": "INTEGER DEFAULT 0",
            "numeroCheque": "TEXT",
            "clientId": "INTEGER",
            "imageFrontPath": "TEXT",
            "imageBackPath": "TEXT",
          },
        );


  Future<Cheque>getCheque(int id) async {
    var map = await this.get(id);
    return Cheque.fromJson(map);
  }

  @override
  Future<List<Cheque>> all() async {
    List<Cheque> cheques = List();
    await super.getAll().then((list) {
      list.forEach((map) => cheques.add(Cheque.fromJson(map)));
    });

    final clientHelper = RepositoryHelper().clientRepository;
    for (Cheque cheque in cheques) {
      if (cheque.clientId != null) {
        cheque.client = Client.fromJson(
          await clientHelper.get(cheque.clientId),
        );
      }
    }
    return cheques;
  }

  @override
  Future<Cheque> first() async {
    return Cheque.fromJson(await super.getFirst());
  }

  Future<List<ChequeClient>> groupByClient() async {
    List<ChequeClient> chequeGroupBy = List();
    String sql = "SELECT "
        "   client.id AS clientId,"
        "   client.name,"
        "   SUM(valorCheque) AS valorCheque,"
        "   AVG(taxaJuros) AS taxaJuros, "
        "   SUM(valorJuros) AS valorJuros,"
        "   SUM(valorLiquido) AS valorLiquido,"
        "   SUM(prazo+compensacao) AS prazo "
        "FROM "
        "   cheque "
        "INNER JOIN client ON client.id = cheque.clientId "
        "GROUP BY "
        "   clientId,"
        "   valorCheque,"
        "   taxaJuros,"
        "   valorJuros,"
        "   valorLiquido,"
        "   prazo,"
        "   compensacao "
        "ORDER BY"
        "   client.name";
    List<Map> map = await super.rawQuery(sql);
    map.forEach(
      (map) => chequeGroupBy.add(
        ChequeClient.fromMap(map),
      ),
    );

    return chequeGroupBy;
  }

  Future<List<Cheque>> getChequeFromDate(
      DateTime initialValue, DateTime endValue) async {
    List<Cheque> cheques = List();
    String sql = "SELECT "
        "   *  ,"
        "   client.id AS clientId,"
        "   client.name AS clientName "
        "FROM "
        "   cheque "
        "INNER JOIN client ON client.id = cheque.clientId "
        " WHERE dataEmissao BETWEEN ${initialValue.millisecondsSinceEpoch}"
        " AND ${endValue.millisecondsSinceEpoch}";
    List<Map> maps = await super.rawQuery(sql);

    maps.forEach(
      (map) => cheques.add(
        Cheque.fromJson(map),
      ),
    );

    return cheques;
  }

  Future<List<ChequeClient>> groupByClientFromDate(
      DateTime initialValue, endValue) async {
    List<ChequeClient> chequeGroupBy = List();
    String sql = "SELECT "
        "   client.id AS clientId,"
        "   client.name,"
        "   SUM(valorCheque) AS valorCheque,"
        "   AVG(taxaJuros) AS taxaJuros, "
        "   SUM(valorJuros) AS valorJuros,"
        "   SUM(valorLiquido) AS valorLiquido,"
        "   SUM(prazo+compensacao) AS prazo "
        "FROM "
        "   cheque "
        "INNER JOIN client ON client.id = cheque.clientId "
        "WHERE dataVencimento BETWEEN ${initialValue.millisecondsSinceEpoch} "
        "AND ${endValue.millisecondsSinceEpoch} "
        "GROUP BY "
        "   clientId,"
        "   valorCheque,"
        "   taxaJuros,"
        "   valorJuros,"
        "   valorLiquido,"
        "   prazo,"
        "   compensacao "
        "ORDER BY"
        "   client.name";
    List<Map> maps = await super.rawQuery(sql);
    maps.forEach(
      (map) => chequeGroupBy.add(
        ChequeClient.fromMap(map),
      ),
    );

    return chequeGroupBy;
  }
}
