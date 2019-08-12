import 'package:bordero/helpers/cheque_helper.dart';
import 'package:bordero/screens/cheques_calculados_screen.dart';
import 'package:bordero/util/date_util.dart';
import 'package:bordero/util/number_util.dart';
import 'package:bordero/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class BorderoScreen extends StatefulWidget {
  final PageController _controller;

  BorderoScreen(this._controller);

  @override
  _BorderoScreenState createState() => _BorderoScreenState();
}

class _BorderoScreenState extends State<BorderoScreen> {
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Cheque> _cheques = List<Cheque>();

  final _dataEmissaoController = TextEditingController();
  final _dataVencimentoController = TextEditingController();
  final _dataPagamentoController = TextEditingController();
  final _prazoController = TextEditingController();
  final _numeroChequeController = TextEditingController();

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

  final FocusNode _focusPrazo = FocusNode();

  _BorderoScreenState() {
    this._dataEmissaoController.text =
        DateUtil.toFormat(DateUtil.firstDateFromMonth());
    _prazoController.text = "0";
    this._numeroChequeController.text = "00001";

    _focusPrazo.addListener(() {
      if (!_focusPrazo.hasFocus && _prazoController.text.isEmpty) {
        _prazoController.text = "0";
      } else if (_prazoController.text == "0") {
        _prazoController.text = "";
      }
    });
  }

  Widget _buildActionButton() {
    return Container(
      margin: EdgeInsets.only(right: 8.0),
      alignment: Alignment.centerRight,
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ),
            onPressed: this._cheques.length > 0
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ChequesCalculadosScreen(this._cheques),
                      ),
                    );
                  }
                : null,//desabilita o botao
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              alignment: Alignment.center,
              width: 18,
              height: 18,
              child: Text(
                this._cheques.length.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.teal,
                ),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, //cor do botão no top
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Borderô"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            child: this._cheques.length == 0 ? null : _buildActionButton(),
          ),
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
                                child: TextField(
                                  controller: _dataVencimentoController,
                                  decoration: InputDecoration(
                                    hintText: "Dt. Vencimento",
                                    labelText: "Data Vencimento",
                                    labelStyle: TextStyle(fontSize: 12),
                                  ),
                                  keyboardType: TextInputType.datetime,
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
                                child: TextField(
                                  readOnly: true,
                                  controller: _dataPagamentoController,
                                  decoration: InputDecoration(
                                    hintText: "Dt. Pagamento",
                                    labelText: "Data Pagamento",
                                    labelStyle: TextStyle(fontSize: 12),
                                  ),
                                  keyboardType: TextInputType.datetime,
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
                                labelStyle: TextStyle(fontSize: 12),
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
                                labelStyle: TextStyle(fontSize: 12),
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
                              focusNode: _focusPrazo,
                              controller: _prazoController,
                              decoration: InputDecoration(
                                hintText: "Prazo",
                                labelText: "Prazo",
                                labelStyle: TextStyle(fontSize: 12),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              onChanged: (text) {
                                int prazo =
                                    NumberUtil.toInt(_prazoController.text);
                                if (prazo != 0) {
                                  calcDateFromPrazo();
                                } else {
                                  print("Nao calculado");
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
                                labelStyle: TextStyle(fontSize: 12),
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
                                labelStyle: TextStyle(fontSize: 12),
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
                                labelStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //Botoes
              Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(bottom: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ButtonTheme(
                      buttonColor: Colors.transparent,
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
                        onPressed:
                            this._cheques.length > 0 ? clearCheques : null,
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

                          if (validator(cheque)) {
                            addCheque(cheque);
                          } else {
                            _showDialogChequeInvalido();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: CustomDrawer(widget._controller),
    );
  }

  /// Seleciona a data no calendário
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

    setState(() {
      _valorLiquidoController.text = cheque.valorLiquido.toStringAsFixed(2);
      _valorJurosController.text = cheque.valorJuros.toStringAsFixed(2);
    });
  }

  /// Inicia um novo cálculo de cheque
  void newCalc() {
    _dataEmissaoController.text = DateUtil.toFormat(DateUtil.firstDateFromMonth());
    _dataPagamentoController.text = "";
    _dataVencimentoController.text = "";

    _valorChequeController.text = "0.00";
    _valorJurosController.text = "0.00";
    _valorLiquidoController.text = "0.00";

    _taxaJurosController.text = "0.00";
    _prazoController.text = "0";
    _numeroChequeController.text = "00001";

    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Novo cheque iniciado ..."),
      ),
    );
  }

  /// Remove os cheques cálculados
  void clearCheques() {
    if (this._cheques.length > 0) {
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
                  setState(() {
                    //remove os cheques
                    this._cheques.clear();
                  });
                  scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Cheques removidos"),
                    ),
                  );
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
    newCalc();
  }

  /// Adiciona um cheque calculado
  void addCheque(cheque) {
    if (cheque != null) {
      setState(() {
        this._cheques.add(cheque);
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Container(
            child: Text("Cheque ${cheque.numeroCheque} adicionado !"),
          ),
        ),
      );
    } else {
      _showDialogChequeInvalido();
    }
  }

  /// Calcula a data do prazo.
  void calcDateFromPrazo() {
    Cheque cheque = _buildCheque();
    //calcula a data de vencimento
    var dataVencimento =
        DateUtil.addDays(cheque.dataEmissao, cheque.prazoTotal);

    //seta a data no campo
    _dataVencimentoController.text = DateUtil.toFormat(dataVencimento);

    //data de pagamento acompanha o vencimento
    _dataPagamentoController.text = DateUtil.toFormat(dataVencimento);

    if (validator(cheque)) {
      calcularCheque(cheque);
    }
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

  /// Alerta de cheque inválido
  void _showDialogChequeInvalido() {
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

  /// Valida as datas do cheque
  bool _validateDataNCalc() {
    //referenciando as datas setada
    var dataEmissao = DateUtil.toDate(_dataEmissaoController.text);
    var dataVencimento = DateUtil.toDate(_dataVencimentoController.text);

    if (_dataEmissaoController.text.isEmpty ||
        _dataVencimentoController.text.isEmpty) {
      return false;
    }

    bool maior = dataEmissao.compareTo(dataVencimento) > 0;
    bool inferior = dataVencimento.compareTo(dataEmissao) < 0;
    //a data de pagamento acompanha a data de vencimento
    _dataPagamentoController.text = _dataVencimentoController.text;

    //se for diferente de null nao sao iguais e se for true a data de vencimento eh menor
    if (inferior) {
      _buildDialog("Atenção",
          "A data de vencimento não pode ser inferior\na data de emissão");

      //seta data de emissao no vencimento
      _dataVencimentoController.text = _dataEmissaoController.text;
    }
    //se true a data de emissao eh maior a data de vencimento
    else if (maior) {
      _buildDialog("Atenção",
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

  /// Cria uma alerta
  void _buildDialog(String title, String message) {
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

  /// Verifica se os dados do cheque são válidos para cálculo.
  bool validator(Cheque cheque) {
    return cheque.prazo != 0 &&
        cheque.taxaJuros.toDouble() != 0.0 &&
        cheque.valorCheque.toDouble() != 0.0;
  }
}
