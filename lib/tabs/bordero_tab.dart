import 'package:bordero/datas/cheque.dart';
import 'package:bordero/screens/cheques_calculados_screen.dart';
import 'package:bordero/util/date_util.dart';
import 'package:bordero/util/number_util.dart';
import 'package:bordero/widgets/custom_drawer.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class BorderoTab extends StatefulWidget {
  final PageController _controller;

  BorderoTab(this._controller);

  @override
  _BorderoTabState createState() => _BorderoTabState();
}

class _BorderoTabState extends State<BorderoTab> {
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Cheque> _cheques = List<Cheque>();

  final _dataEmissaoController = TextEditingController();
  final _dataVencimentoController = TextEditingController();
  final _dataPagamentoController = TextEditingController();
  final _prazoController = TextEditingController();
  final _numeroChequeController = TextEditingController();

  final _countCheques = TextEditingController();

  final _valorChequeController = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  final _taxaJurosController = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  final _valorJurosController = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  final _valorLiquidoController = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );

  _BorderoTabState() {
    _prazoController.text = "0";
    this._numeroChequeController.text = "00001";
    _countCheques.text = this._cheques.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Borderô"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: this._cheques.length > 0
                ? () {
                    //cheques calculados
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ChequesCalculadosScreen(this._cheques)));
                  }
                : null,
          ),
          // a
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                _selectDate(_dataEmissaoController);
                              },
                              child: IgnorePointer(
                                child: TextFormField(
                                  controller: _dataEmissaoController,
                                  decoration: InputDecoration(
                                    hintText: "Dt. Emissao",
                                    labelText: "Data Emissão",
                                    labelStyle: TextStyle(fontSize: 12),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                  validator: (text) {
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                _selectDate(
                                    _dataVencimentoController); // Call Function that has showDatePicker()
                              },
                              child: IgnorePointer(
                                child: TextFormField(
                                  controller: _dataVencimentoController,
                                  decoration: InputDecoration(
                                    hintText: "Dt. Vencimento",
                                    labelText: "Data Vencimento",
                                    labelStyle: TextStyle(fontSize: 12),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                  validator: (text) {
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                _selectDate(
                                    _dataPagamentoController); // Call Function that has showDatePicker()
                              },
                              child: IgnorePointer(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _dataPagamentoController,
                                  decoration: InputDecoration(
                                    hintText: "Dt. Pagamento",
                                    labelText: "Data Pagamento",
                                    labelStyle: TextStyle(fontSize: 12),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                  validator: (text) {
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //linha 2
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              controller: _valorChequeController,
                              decoration: InputDecoration(
                                hintText: "Valor Cheque",
                                labelText: "Valor Cheque",
                                labelStyle: TextStyle(fontSize: 14),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              onChanged: (text) {
                                Cheque cheque = _buildCheque();
                                if (validator(cheque)) {
                                  calcularCheque(cheque);
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextField(
                              controller: _taxaJurosController,
                              decoration: InputDecoration(
                                hintText: "% Taxa de Juros",
                                labelText: "% Taxa de Juros",
                                labelStyle: TextStyle(fontSize: 14),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              onChanged: (text) {
                                Cheque cheque = _buildCheque();
                                if (validator(cheque)) {
                                  calcularCheque(cheque);
                                }else{
                                  print("Cheque invalido");
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //linha 3
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              controller: _prazoController,
                              decoration: InputDecoration(
                                hintText: "Prazo",
                                labelText: "Prazo",
                                labelStyle: TextStyle(fontSize: 14),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (text) {
                                int prazo =
                                    NumberUtil.toInt(_prazoController.text);
                                if (prazo != 0) {
                                  calcDateFromPrazo( _buildCheque());
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextField(
                              readOnly: true,
                              controller: _valorJurosController,
                              decoration: InputDecoration(
                                hintText: "Valor Juros",
                                labelText: "Valor Juros",
                                labelStyle: TextStyle(fontSize: 14),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //linha 4
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              readOnly: true,
                              controller: _valorLiquidoController,
                              decoration: InputDecoration(
                                hintText: "Valor Líquido",
                                labelText: "Valor Líquido",
                                labelStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextField(
                              controller: _numeroChequeController,
                              decoration: InputDecoration(
                                hintText: "Número Cheque",
                                labelText: "Número Cheque",
                                labelStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Text("Cheques: ${_countCheques.text}"),
                    ],
                  ),
                ),
              ),
              //Botoes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ButtonTheme(
                    height: 50.0,
                    minWidth: 100, //MediaQuery.of(context).size.width-20,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Limpar",
                        style: TextStyle(fontSize: 16),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: this._cheques.length > 0 ? clearCheques : null,
                    ),
                  ),
                  ButtonTheme(
                    height: 50.0,
                    minWidth: 100, //MediaQuery.of(context).size.width-20,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Novo",
                        style: TextStyle(fontSize: 16),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: newCalc,
                    ),
                  ),
                  ButtonTheme(
                    height: 50.0,
                    minWidth: 100, //MediaQuery.of(context).size.width-20,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Salvar",
                        style: TextStyle(fontSize: 16),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        var cheque = _buildCheque();

                        if(validator(cheque)) {
                          addCheque(cheque);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: CustomDrawer(widget._controller),
    );
  }

  Future _selectDate(TextEditingController controller) async {
    final DateTime now = DateTime.now();
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, 1),
      lastDate: DateTime(now.year + 9999, now.month, now.day),
    );
    if (picked != null) {
      setState(() {
        //seta a data no componente
        controller.text = DateUtil.toFormat(picked);

        this._validateDataNCalc();
//          DateTime dataEmissao = DateUtil.toDate(_dataEmissaoController.text);
//          DateTime dataVencimento =
//          DateUtil.toDate(_dataVencimentoController.text);
//          calcPrazoFromDate(dataEmissao, dataVencimento);
      });
    }
  }

  ///Obtem os dados do cheque dos campos
  Cheque _buildCheque() {
    var dtEmissao = DateUtil.toDate(_dataEmissaoController.text);
    var dtVencimento = DateUtil.toDate(_dataVencimentoController.text);
    var dtPagamento = DateUtil.toDate(_dataPagamentoController.text);

    var valorCheque = NumberUtil.toDecimal(_valorChequeController.text);
    var taxaJuros = NumberUtil.toDecimal(_taxaJurosController.text);
    var numeroCheque = (_numeroChequeController.text);

    //o prazo q eh usado para calcular o juros
    int prazo = NumberUtil.toInt(_prazoController.text);

    //calculando cheque
    Cheque ch = Cheque.calc(dtEmissao, dtVencimento, dtPagamento, prazo,
        taxaJuros, valorCheque, numeroCheque);

    return ch;
  }

  ///Calcula um cheque
  void calcularCheque(Cheque cheque) {
    //setando prazo total para calculo dos valorJurosCalc
    cheque.setPrazoTotal(cheque.prazo, cheque.compensacao);

    //fazendo os calculos dos valores da estrutura
    cheque.setJuros(cheque.valorCheque, cheque.taxaJuros, cheque.prazoTotal);

    //seta o valor liquido
    cheque.setValorLiquido(cheque.valorCheque, cheque.valorJuros);
  }

  void newCalc() {
    _dataEmissaoController.text = "";
    _dataPagamentoController.text = "";
    _dataVencimentoController.text = "";

    _valorChequeController.text = "0.00";
    _valorJurosController.text = "0.00";
    _valorLiquidoController.text = "0.00";

    _taxaJurosController.text = "0.00";
    _prazoController.text = "0.00";
    _numeroChequeController.text = "00001";

    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Novo cheque iniciado ..."),
      ),
    );
  }

  void clearCheques() {
    if (this._cheques.length > 0) {
      this._cheques.clear();
      _countCheques.text = "0";
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Cheques removidos"),
        ),
      );
    } else {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Não há cheques calculados"),
        ),
      );
    }
    newCalc();
  }

  void addCheque(cheque) {

    if (cheque != null) {
      this._cheques.add(cheque);
      this._numeroChequeController.text =
          "0000" + (this._cheques.length + 1).toString();
    } else {
      _dialogChequeInvalido();
    }
  }

  /// Calcula a data do prazo.
  Cheque calcDateFromPrazo( Cheque cheque) {
    print(cheque);
    if (validator(cheque)) {
      //calcula a data de vencimento
      var dataVencimento =
          DateUtil.addDays(cheque.dataEmissao, cheque.prazoTotal);

      //seta a data no campo
      _dataVencimentoController.text = DateUtil.toFormat(dataVencimento);

      //data de pagamento acompanha o vencimento
      _dataPagamentoController.text = DateUtil.toFormat(dataVencimento);

      calcularCheque(cheque);
    }
    return cheque;
  }

  /// Calcula o prazo a partir da data de emissao e vencimento.
  void calcPrazoFromDate(DateTime dtEmissao, DateTime dtVencimento) {
    //calcula o prazo
    int prazo = DateUtil.getDiffDays(dtEmissao, dtVencimento);

    //seta o prazo no campo
    _prazoController.text = prazo.toString();

    Cheque cheque = _buildCheque();

    if (cheque != null) {
      calcularCheque(cheque);
    }
  }

  void _dialogChequeInvalido() {
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

  bool _validateDataNCalc() {
    //referenciando as datas setada
    var dataEmissao = DateUtil.toDate(_dataEmissaoController.text);
    var dataVencimento = DateUtil.toDate(_dataVencimentoController.text);

    if(_dataEmissaoController.text.isEmpty ||
        _dataVencimentoController.text.isEmpty){
      return false;
    }

//    print("Emissao: $dataEmissao");
//    print("Vencimento $dataVencimento");
    bool maior = dataEmissao.compareTo(dataVencimento) > 0;
    bool inferior = dataVencimento.compareTo(dataEmissao) < 0;
    //a data de pagamento acompanha a data de vencimento
    _dataPagamentoController.text = _dataVencimentoController.text;

    //se for diferente de null nao sao iguais e se for true a data de vencimento eh menor
    if (inferior) {
      _buildAlert("Atenção",
          "A data de vencimento não pode ser inferior\na data de emissão");

      //seta data de emissao no vencimento
      _dataVencimentoController.text = _dataEmissaoController.text;
    }
    //se true a data de emissao eh maior a data de vencimento
    else if (maior) {
      _buildAlert("Atenção",
          "A data de emissão não pode ser superior\na data de vencimento.\n");
      //entao sao iguais
      _dataEmissaoController.text = _dataVencimentoController.text;
    } else {
      calcPrazoFromDate(dataEmissao, dataVencimento);
      calcularCheque(_buildCheque());
      return true;
    }
    return false;
  }

  _buildAlert(String title, String message) {
    void _dialogChequeInvalido() {
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
  }

  /// Verifica se os dados do cheque são válidos para cálculo.
  /// true Válido
  /// false Inválidos
  bool validator(Cheque cheque) {
//    if (_dataEmissaoController.text.isEmpty ||
//        _dataVencimentoController.text.isEmpty ||
//        _prazoController.text.isEmpty ||
//        valorCheque < Decimal.one ||
//        taxaJuros <= Decimal.zero) {
//      return null;
//    }
    //se ambos forem diferentes de zero ao mesmo tempo
    return cheque.prazo != 0 &&
        cheque.taxaJuros != Decimal.zero &&
        cheque.valorCheque != Decimal.zero;
  }


}
