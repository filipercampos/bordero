import 'package:bordero/util/date_util.dart';
import 'package:bordero/util/number_util.dart';
import 'package:decimal/decimal.dart';

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
  String imagePath;
  int clientId;

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

  Cheque.fromJson(Map<String, dynamic> json) {
    id = json["id"];

    dataEmissao =
        DateUtil.toDateFromMillisecondsSinceEpoch(json["dataEmissao"]);
    dataVencimento =
        DateUtil.toDateFromMillisecondsSinceEpoch(json["dataVencimento"]);
    dataPagamento =
        DateUtil.toDateFromMillisecondsSinceEpoch(json["dataPagamento"]);
    valorCheque = NumberUtil.toDecimalFromDouble(json["valorCheque"]);
    taxaJuros = NumberUtil.toDecimalFromDouble(json["taxaJuros"]);
    valorJuros = NumberUtil.toDecimalFromDouble(json["valorJuros"]);
    valorLiquido = NumberUtil.toDecimalFromDouble(json["valorLiquido"]);
    prazo = json["prazo"];
    compensacao = json["compensacao"];
    numeroCheque = json["numeroCheque"];
    nominal = json["nominal"];
    imagePath = json["imagePath"];
    clientId = json["clientId"];
    setPrazoTotal(prazo, compensacao);
  }

  Map<String, dynamic>  toJson() {
    Map<String, dynamic> map = {
      "dataEmissao": dataEmissao.millisecondsSinceEpoch,
      "dataVencimento": dataVencimento.millisecondsSinceEpoch,
      "dataPagamento":
          dataPagamento != null ? dataPagamento.millisecondsSinceEpoch : null,
      "valorCheque": valorCheque.toDouble(),
      "taxaJuros": taxaJuros.toDouble(),
      "valorJuros": valorJuros.toDouble(),
      "valorLiquido": valorLiquido.toDouble(),
      "prazo": prazo,
      "compensacao": compensacao,
      "numeroCheque": numeroCheque,
      "nominal": nominal,
      "clientId": clientId,
      "imagePath": imagePath
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Cheque.calc(
      DateTime dataEmissao,
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
    return 'Cheque{id: $id, dataEmissao: $dataEmissao, dataVencimento: $dataVencimento, dataPagamento: $dataPagamento, valorCheque: $valorCheque, taxaJuros: $taxaJuros, valorJuros: $valorJuros, valorLiquido: $valorLiquido, prazo: $prazo, compensacao: $compensacao, numeroCheque: $numeroCheque, nominal: $nominal, prazoTotal: $prazoTotal, imagePath: $imagePath, clientId: $clientId}';
  }


}
