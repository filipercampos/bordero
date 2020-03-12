import 'package:bordero/util/date_util.dart';
import 'package:bordero/util/number_util.dart';

import 'client.dart';

class Cheque {
  int id;
  DateTime dataEmissao;
  DateTime dataVencimento;
  DateTime dataPagamento;

  double valorCheque;
  double taxaJuros;
  double valorJuros;
  double valorLiquido;
  int prazo;
  int compensacao;
  String numeroCheque;
  int prazoTotal;
  String imageFrontPath;
  String imageBackPath;
  int clientId;
  Client client;

  Cheque() {
    var dataAtual = DateTime.now();
    //atributos incializados com a data do sistema
    this.dataEmissao = dataAtual;
    this.dataVencimento = dataAtual;
    this.taxaJuros = 0.0;
    this.valorCheque = 0.0;
    this.valorJuros = 0.0;
    this.valorLiquido = 0.0;
    this.prazo = 0;
    this.compensacao = 0;
  }

  Cheque.fromJson(Map<String, dynamic> json) {
    id = json["id"];

    dataEmissao =
        DateUtil.toDateFromMillisecondsSinceEpoch(json["dataEmissao"]);
    dataVencimento =
        DateUtil.toDateFromMillisecondsSinceEpoch(json["dataVencimento"]);
    dataPagamento =
        DateUtil.toDateFromMillisecondsSinceEpoch(json["dataPagamento"]);
    valorCheque = json["valorCheque"];
    taxaJuros = json["taxaJuros"];
    valorJuros = json["valorJuros"];
    valorLiquido = json["valorLiquido"];
    prazo = json["prazo"];
    compensacao = json["compensacao"];
    numeroCheque = json["numeroCheque"];
    imageFrontPath = json["imageFrontPath"];
    imageBackPath = json["imageBackPath"];
    clientId = json["clientId"];

    if (json.containsKey("clientName")) {
      this.client = Client();
      this.client.id = this.clientId;
      this.client.name = json["clientName"];
    }
    setPrazoTotal(prazo, compensacao);

  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "dataEmissao": dataEmissao.millisecondsSinceEpoch,
      "dataVencimento": dataVencimento.millisecondsSinceEpoch,
      "dataPagamento":
          dataPagamento != null ? dataPagamento.millisecondsSinceEpoch : null,
      "valorCheque": valorCheque,
      "taxaJuros": taxaJuros,
      "valorJuros": valorJuros,
      "valorLiquido": valorLiquido,
      "prazo": prazo,
      "compensacao": compensacao,
      "numeroCheque": numeroCheque,
      "clientId": clientId,
      "imageFrontPath": imageFrontPath,
      "imageBackPath": imageBackPath
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
      double taxaJuros,
      double valorCheque,
      String numeroCheque) {
    this.prazo = prazo;
    this.dataEmissao = dataEmissao;
    this.dataVencimento = dataVencimento;
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
  }

  setJuros(double valorCheque, double taxaJuros, int prazo) {
    this.valorJuros = calcularJuros(valorCheque, taxaJuros, prazo);
  }

  calcularJuros(double valorCheque, double taxaJuros, int prazo) {
    double valorChequeCalc = valorCheque;
    //taxaJurosCalc / 100
    taxaJuros = taxaJuros / 100;

    //valorChequeCalc * taxaJurosCalc
    valorChequeCalc = valorChequeCalc * taxaJuros;

    //valorChequeCalc / 30
    valorChequeCalc = valorChequeCalc / 30;

    //valorChequeCalc * prazo
    valorChequeCalc = valorChequeCalc * double.parse(prazo.toString());

    valorChequeCalc = NumberUtil.toDoubleDecimal(
      valorChequeCalc.toString(),
      scale: 2,
    );

    //valor do valorChequeCalc eh o valor final do cheque
    return valorChequeCalc;
  }

  setValorLiquido(double valorCheque, double valorJuros) {
    this.valorCheque = valorCheque;
    this.valorJuros = valorJuros;
    this.valorLiquido = valorCheque - valorJuros;
  }

  setPrazoTotal(int prazo, int compensacao) {
    this.prazoTotal = prazo + compensacao;
  }

  void setClient(Client client) {
    if (client != null) {
      this.client = client;
      this.clientId = client.id;
    }
  }

  @override
  String toString() {
    return 'Cheque{id: $id, '
        'dataEmissao: $dataEmissao, '
        'dataVencimento: $dataVencimento, '
        'dataPagamento: $dataPagamento, '
        'valorCheque: $valorCheque, '
        'taxaJuros: $taxaJuros, '
        'valorJuros: $valorJuros, '
        'valorLiquido: $valorLiquido, '
        'prazo: $prazo, '
        'compensacao: $compensacao, '
        'numeroCheque: $numeroCheque, '
        'imageFrontPath: $imageFrontPath, '
        'imageBackPath: $imageBackPath, '
        'clientId: $clientId,'
        'client: ${client != null ? client.name : null}';
  }

  Cheque.clone(Cheque ch) {
    this.id = ch.id;
    this.dataEmissao = ch.dataEmissao;
    this.dataVencimento = ch.dataVencimento;
    this.dataPagamento = ch.dataPagamento;
    this.valorCheque = ch.valorCheque;
    this.taxaJuros = ch.taxaJuros;
    this.valorJuros = ch.valorJuros;
    this.valorLiquido = ch.valorLiquido;
    this.prazo = ch.prazo;
    this.compensacao = ch.compensacao;
    this.numeroCheque = ch.numeroCheque;
    this.clientId = ch.clientId;
    this.imageFrontPath = ch.imageFrontPath;
    this.imageBackPath = ch.imageBackPath;
    this.client = ch.client;
    this.clientId = ch.clientId;
  }
}
