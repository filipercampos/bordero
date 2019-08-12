import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "chequeTable";
final String idColumn = "id";
final String dataEmissaoColumn = "dataEmissao";
final String dataVencimentoColumn = "dataVencimento";
final String dataPagamentoColumn = "dataPagamento";

final String valorChequeColumn = "valorCheque";
final String taxaJurosColumn = "taxaJuros";
final String valorJurosColumn = "valorJuros";
final String valorLiquidoColumn = "valorLiquido";
final String prazoColumn = "prazo";
final String compensacaoColumn = "compensacao";
final String numeroChequeColumn = "numeroCheque";
final String nominalColumn = "nominal";

class ChequeHelper {
  static final ChequeHelper _instance = ChequeHelper.internal();

  factory ChequeHelper() => _instance;

  ChequeHelper.internal();

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
              "$dataEmissaoColumn    INTEGER,   "
              "$dataVencimentoColumn INTEGER,"
              "$dataPagamentoColumn  INTEGER,"
              "$valorChequeColumn    REAL"
              "$taxaJurosColumn      REAL"
              "$valorJurosColumn     REAL"
              "$valorLiquidoColumn   REAL"
              "$prazoColumn          INTEGER"
              "$compensacaoColumn    INTEGER"
              "$numeroChequeColumn   TEXT"
              "$nominalColumn        TEXT");
        });
  }

  Future<Cheque> saveCheque(Cheque cheque) async {
    Database dbCheque = await db;
    cheque.id = await dbCheque.insert(tableName, cheque.toMap());
    return cheque;
  }

  Future<Cheque> getCheque(int id) async {
    Database dbCheque = await db;
    List<Map> maps = await dbCheque.query(tableName,
        columns: [
          idColumn,
          dataEmissaoColumn,
          dataVencimentoColumn,
          dataPagamentoColumn,
          valorChequeColumn,
          taxaJurosColumn,
          valorJurosColumn,
          valorLiquidoColumn,
          prazoColumn,
          compensacaoColumn,
          numeroChequeColumn,
          nominalColumn,
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Cheque.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteCheque(int id) async {
    Database dbCheque = await db;
    return await dbCheque
        .delete(tableName, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateCheque(Cheque cheque) async {
    Database dbCheque = await db;
    return await dbCheque.update(tableName, cheque.toMap(),
        where: "$idColumn = ?", whereArgs: [cheque.id]);
  }

  Future<List> getAllCheques() async {
    Database dbCheque = await db;
    List listMap = await dbCheque.rawQuery("SELECT * FROM $tableName");
    List<Cheque> listCheque = List();
    for (Map m in listMap) {
      listCheque.add(Cheque.fromMap(m));
    }
    return listCheque;
  }

  Future<int> count() async {
    Database dbCheque = await db;
    return Sqflite.firstIntValue(
        await dbCheque.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future close() async {
    Database dbCheque = await db;
    dbCheque.close();
  }
}

class Cheque {
  int id;
  DateTime dataEmissao;
  DateTime dataVencimento;
  DateTime dataPagamento;

  Decimal valorCheque;
  Decimal taxaJuros;
  Decimal valorJuros;
  Decimal valorLiquido;
  int prazo;
  int compensacao;
  String numeroCheque;
  String nominal;
  int prazoTotal;

  Cheque() {
    var dataAtual = DateTime.now();
    //atributos incializados com a data do sistema
    this.dataEmissao = dataAtual;
    this.dataVencimento = dataAtual;
    this.taxaJuros = Decimal.zero;
    this.valorCheque = Decimal.zero;
    this.valorJuros = Decimal.zero;
    this.valorLiquido = Decimal.zero;
    this.prazo = 0;
    this.compensacao = 0;
    this.nominal = "";
  }


  Cheque.fromMap(Map map) {
    id = map[ idColumn];
    dataEmissao = map[ dataEmissaoColumn];
    dataVencimento = map[ dataVencimentoColumn];
    dataPagamento = map[ dataPagamentoColumn];
    valorCheque = map[valorChequeColumn];
    taxaJuros = map[taxaJurosColumn];
    valorJuros = map[valorJurosColumn];
    valorLiquido = map[valorLiquidoColumn];
    prazo = map[prazoColumn];
    compensacao = map[compensacaoColumn];
    numeroCheque = map[numeroChequeColumn];
    nominal = map[nominalColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      dataEmissaoColumn: dataEmissao,
      dataVencimentoColumn: dataVencimento,
      dataPagamentoColumn: dataPagamento,
      valorChequeColumn: valorCheque,
      taxaJurosColumn: taxaJuros,
      valorJurosColumn: valorJuros,
      valorLiquidoColumn: valorLiquido,
      prazoColumn: prazo,
      compensacaoColumn: compensacao,
      numeroChequeColumn: numeroCheque,
      nominalColumn: nominal,

    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  Cheque.calc(DateTime dataEmissao,
      DateTime dataVencimento,
      DateTime dataPagamento,
      int prazo,
      Decimal taxaJuros,
      Decimal valorCheque,
      String numeroCheque) {
    this.prazo = prazo;
    this.dataEmissao = dataEmissao;
    this.dataVencimento = dataVencimento;
    this.dataPagamento = dataPagamento;
    this.compensacao = 0;

    //vou persistir no banco da forma que ela entrar
    this.taxaJuros = taxaJuros;
    //valor base
    this.valorCheque = valorCheque;

    //setando prazo total para calculo dos valorJurosCalc
    setPrazoTotal(prazo, compensacao);

    //fazendo os calculos dos valores da estrutura
    setJuros(this.valorCheque, this.taxaJuros, prazoTotal);

    //seta o valor liquido
    setValorLiquido(this.valorCheque, this.valorJuros);

    this.numeroCheque = numeroCheque;
    this.nominal = nominal;
  }

  setJuros(Decimal valorCheque, Decimal taxaJuros, int prazo) {
    this.valorJuros = calcularJuros(valorCheque, taxaJuros, prazo);
  }

  calcularJuros(Decimal valorCheque, Decimal taxaJuros, int prazo) {
    Decimal valorChequeCalc = valorCheque;
    //taxaJurosCalc / 100
    taxaJuros = taxaJuros / Decimal.parse("100");

    //valorChequeCalc * taxaJurosCalc
    valorChequeCalc = valorChequeCalc * taxaJuros;

    //valorChequeCalc / 30
    valorChequeCalc = valorChequeCalc / Decimal.parse("30");

    //valorChequeCalc * prazo
    valorChequeCalc = valorChequeCalc * Decimal.parse(prazo.toString());

    //valor do valorChequeCalc eh o valor final do cheque
    return Decimal.parse(valorChequeCalc.toStringAsPrecision(2));
  }

  setValorLiquido(Decimal valorCheque, Decimal valorJuros) {
    this.valorCheque = valorCheque;
    this.valorJuros = valorJuros;
    this.valorLiquido = valorCheque - valorJuros;
  }

  setPrazoTotal(int prazo, int compensacao) {
    this.prazoTotal = prazo + compensacao;
  }

  @override
  String toString() {
    return 'Cheque{dataEmissao: $dataEmissao, dataVencimento: $dataVencimento, dataPagamento: $dataPagamento, valorCheque: $valorCheque, taxaJuros: $taxaJuros, valorJuros: $valorJuros, valorLiquido: $valorLiquido, prazo: $prazo, compensacao: $compensacao, numeroCheque: $numeroCheque}';
  }
}
