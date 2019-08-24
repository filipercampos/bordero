import 'package:bordero/models/cheque.dart';
import 'package:bordero/models/client.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/util/date_util.dart';
import 'package:bordero/util/number_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

 class BorderoHelper {

  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final GlobalKey<ScaffoldState> scaffoldKey ;
  final List<Cheque> cheques = List<Cheque>();

  final TextEditingController dataEmissaoController ;
  final TextEditingController dataVencimentoController ;
  final TextEditingController dataPagamentoController ;
  final TextEditingController prazoController ;
  final TextEditingController numeroChequeController ;
  final TextEditingController nominalController ;
  final MoneyMaskedTextController valorChequeController;
  final MoneyMaskedTextController taxaJurosController ;
  final MoneyMaskedTextController valorJurosController ;
  final MoneyMaskedTextController valorLiquidoController;

  Client client;
  String imageFrontPath;
  String imageBackPath;

  BorderoHelper(this.context, this.formKey, this.scaffoldKey,
      this.dataEmissaoController, this.dataVencimentoController,
      this.dataPagamentoController, this.prazoController,
      this.numeroChequeController, this.valorChequeController,
      this.taxaJurosController, this.valorJurosController,
      this.valorLiquidoController, this.nominalController);
  

  ///Obtem os dados do cheque dos campos
  Cheque buildCheque() {
    var dtEmissao = DateUtil.toDate(dataEmissaoController.text);
    var dtVencimento = DateUtil.toDate(dataVencimentoController.text);
    var dtPagamento = DateUtil.toDate(dataPagamentoController.text);

    var valorCheque = NumberUtil.toDecimal(valorChequeController.text);
    var taxaJuros = NumberUtil.toDecimal(taxaJurosController.text);
    var numeroCheque = (numeroChequeController.text);

    //o prazo q eh usado para calcular o juros
    int prazo = NumberUtil.toInt(prazoController.text);

    //calculando cheque
    Cheque ch = Cheque.calc(dtEmissao, dtVencimento, dtPagamento, prazo,
        taxaJuros, valorCheque, numeroCheque);

    ch.setClient(client);

    ch.imageFrontPath = imageFrontPath;
    ch.imageBackPath = imageBackPath;
    return ch;
  }


  /// Adiciona um cheque calculado
  void addCheque() {
    var cheque = buildCheque();

    if (validator(cheque)) {
      this.cheques.add(cheque);
      this.numeroChequeController.text =
      "0000${(this.cheques.length + 1).toString()}";

      //notifica que a tela deve ser redesenhada
//      setState(() {});

      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Container(
            child: Text("Cheque ${cheque.numeroCheque} adicionado !"),
          ),
        ),
      );
    } else {
      showDialogChequeInvalido();
    }
  }

  /// Inicia um novo cálculo de cheque
  void newCalc() {
    dataEmissaoController.text = ""; //DateUtil.toFormat(DateUtil.firstDateFromMonth());
    dataPagamentoController.text = "";
    dataVencimentoController.text = "";

    valorChequeController.text = "0.00";
    valorJurosController.text = "0.00";
    valorLiquidoController.text = "0.00";

    taxaJurosController.text = "0.00";
    prazoController.text = "0";
    numeroChequeController.text =
    "0000${(this.cheques.length + 1).toString()}";

    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Novo cheque iniciado ..."),
      ),
    );
  }

  ///Calcula um cheque
  void calcularCheque(Cheque cheque) {
    //setando prazo total para calculo dos valorJurosCalc
    cheque.setPrazoTotal(cheque.prazo, cheque.compensacao);

    //fazendo os calculos dos valores da estrutura
    cheque.setJuros(cheque.valorCheque, cheque.taxaJuros, cheque.prazoTotal);

    //seta o valor liquido
    cheque.setValorLiquido(cheque.valorCheque, cheque.valorJuros);


      valorLiquidoController.text = cheque.valorLiquido.toStringAsFixed(2);
      valorJurosController.text = cheque.valorJuros.toStringAsFixed(2);

  }

  /// Calcula a data do prazo.
  void calcDateFromPrazo() {
    Cheque cheque = buildCheque();
    //calcula a data de vencimento
    var dataVencimento =
    DateUtil.addDays(cheque.dataEmissao, cheque.prazoTotal);

    //seta a data no campo
    dataVencimentoController.text = DateUtil.toFormat(dataVencimento);

    //data de pagamento acompanha o vencimento
    dataPagamentoController.text = DateUtil.toFormat(dataVencimento);

    if (validator(cheque)) {
      calcularCheque(cheque);
    }
  }

  /// Calcula o prazo a partir da data de emissao e vencimento.
  void calcPrazoFromDate(DateTime dtEmissao, DateTime dtVencimento) {
    //calcula o prazo
    int prazo = DateUtil.getDiffDays(dtEmissao, dtVencimento);

    //seta o prazo no campo
    prazoController.text = prazo.toString();

    Cheque cheque = buildCheque();

    if (cheque != null) {
      calcularCheque(cheque);
    }
  }

  /// Remove os cheques cálculados
  void clearCheques() {
    if (this.cheques.length > 0) {
      // flutter defined function
      showDialog(
        context: this.context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
              "Atenção",
              textAlign: TextAlign.center,
            ),
            content:
            Text("Deseja realmente remover todos os cheques calculados ?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Não"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: () {
                  Navigator.of(context).pop();
//                  setState(() {
                    //remove os cheques
                    this.cheques.clear();
//                  });
                  scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Cheques removidos"),
                    ),
                  );
                  newCalc();
                },
              ),
            ],
          );
        },
      );
    } else {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Não há cheques calculados"),
        ),
      );
    }
  }


  /// Alerta de cheque inválido
  void showDialogChequeInvalido() {
    // flutter defined function
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "Atenção",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Para calcular um cheque informe:",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Valor do cheque",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "% Taxa de Juros",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Prazo",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "*Para setar o prazo, escolha a data de vencimento do cheque no calendário",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Cria uma alerta
  void buildDialog(String title, String message) {
    // flutter defined function
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ///Auto complete for client
  Future<List<Client>> getSuggestions(String search) async {
    final helper = RepositoryHelper().clientRepository;
    List<Client> clients = List();
    helper.debugExecuteQuery = true;
    await helper.rawQueryMap({"name": search},like: true).then((list) {
      list.forEach((map) => clients.add(Client.fromJson(map)));
    });
    return clients;
  }

  /// Verifica se os dados do cheque são válidos para cálculo.
  bool validator(Cheque cheque) {
    if(cheque == null) return false;
    return cheque.prazo != 0 &&
        cheque.taxaJuros.toDouble() != 0.0 &&
        cheque.valorCheque.toDouble() != 0.0;
  }

  /// Valida as datas do cheque
  bool validateDataNCalc() {
    //referenciando as datas setada
    var dataEmissao = DateUtil.toDate(dataEmissaoController.text);
    var dataVencimento = DateUtil.toDate(dataVencimentoController.text);

    if (dataEmissaoController.text.isEmpty ||
        dataVencimentoController.text.isEmpty) {

      if(dataVencimentoController.text.isEmpty && prazoController.text != "0"){
        calcDateFromPrazo();//vai setar o vencimento
        //redefine novamente a data
        dataVencimento = DateUtil.toDate(dataVencimentoController.text);
      }else{
        return false;
      }
    }

    bool maior = dataEmissao.compareTo(dataVencimento) > 0;
    bool inferior = dataVencimento.compareTo(dataEmissao) < 0;
    //a data de pagamento acompanha a data de vencimento
    dataPagamentoController.text = dataVencimentoController.text;

    //se for diferente de null nao sao iguais e se for true a data de vencimento eh menor
    if (inferior) {
      buildDialog("Atenção",
          "A data de vencimento não pode ser inferior\na data de emissão");

      //seta data de emissao no vencimento
      dataVencimentoController.text = dataEmissaoController.text;
    }
    //se true a data de emissao eh maior a data de vencimento
    else if (maior) {
      buildDialog("Atenção",
          "A data de emissão não pode ser superior\na data de vencimento.\n");
      //entao sao iguais
      dataEmissaoController.text = dataVencimentoController.text;
    } else {
      calcPrazoFromDate(dataEmissao, dataVencimento);

      calcularCheque(buildCheque());

      return true;
    }
    return false;
  }

  String validateImages(List images) {
    if (images.isEmpty) {
      return "Adicione imagens ao produto";
    }
    return null;
  }

  void test() {
    //teste
    var de = DateTime(2019, 06, 1);
    var dv = DateTime.now();
    dataEmissaoController.text = DateUtil.toFormat(de);
    dataVencimentoController.text = DateUtil.toFormat(dv);

    valorChequeController.text = "4500.00";
    taxaJurosController.text = "5.00";
    calcPrazoFromDate(de, dv);
  }

}