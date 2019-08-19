import 'dart:io';

import 'package:bordero/helpers/bordero_helper.dart';
import 'package:bordero/models/cheque.dart';
import 'package:bordero/models/client.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/screens/cheques_bordero_screen.dart';
import 'package:bordero/util/date_util.dart';
import 'package:bordero/util/number_util.dart';
import 'package:bordero/widgets/custom_drawer.dart';
import 'package:bordero/widgets/image_source_sheet.dart';
import 'package:bordero/widgets/images_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class BorderoScreen extends StatefulWidget {
  final PageController _controller;

  BorderoScreen(this._controller);

  @override
  _BorderoScreenState createState() => _BorderoScreenState();
}

class _BorderoScreenState extends State<BorderoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _dataEmissaoController = TextEditingController();
  final _dataVencimentoController = TextEditingController();
  final _dataPagamentoController = TextEditingController();
  final _prazoController = TextEditingController();
  final _numeroChequeController = TextEditingController();
  final _nominalController = TextEditingController();

  final _valorChequeController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
  final _taxaJurosController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
  final _valorJurosController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
  final _valorLiquidoController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
  );

  final FocusNode _focusPrazo = FocusNode();
  BorderoHelper helper;

  _BorderoScreenState() {
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
            onPressed: this.helper.cheques.length > 0
                ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ChequesBorderoScreen(this.helper.cheques),
                ),
              );
            }
                : null, //desabilita o botao
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              alignment: Alignment.center,
              width: 18,
              height: 18,
              child: Text(
                this.helper.cheques.length.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Theme
                      .of(context)
                      .primaryColor,
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
  void initState() {
    super.initState();
    helper = BorderoHelper(
        context,
        _formKey,
        _scaffoldKey,
        _dataEmissaoController,
        _dataVencimentoController,
        _dataPagamentoController,
        _prazoController,
        _numeroChequeController,
        _valorChequeController,
        _taxaJurosController,
        _valorJurosController,
        _valorLiquidoController);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Borderô"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            child:
            this.helper.cheques.length == 0 ? null : _buildActionButton(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          //ocupa um pedaço da tela
          //mas permite rolar os elementos
          child: SingleChildScrollView(
            child: SizedBox(
              height: height - 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
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
                                Cheque cheque = helper.buildCheque();
                                if (helper.validator(cheque)) {
                                  helper.calcularCheque(cheque);
                                  setState(() {});
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
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(5),
                              ],
                              decoration: InputDecoration(
                                hintText: "% Taxa de Juros",
                                labelText: "% Taxa de Juros",
                                labelStyle: TextStyle(fontSize: 12),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              onChanged: (text) {
                                Cheque cheque = helper.buildCheque();
                                if (helper.validator(cheque)) {
                                  helper.calcularCheque(cheque);
                                  setState(() {});
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
                                  helper.calcDateFromPrazo();
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
                      SizedBox(
                        height: 10,
                      ),
                      TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _nominalController,
                          decoration: InputDecoration(
                            hintText: "Nominal",
                            labelText: "Cliente",
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                        ),
                        suggestionsCallback: (search) async {
                          return await helper.getSuggestions(search);
                        },
                        itemBuilder: (context, Client suggestion) {
                          return ListTile(
                            leading: Icon(Icons.account_box),
                            title: Text(suggestion.name ?? ""),
                            subtitle: Text(suggestion.phone1 ?? ""),
                          );
                        },
                        onSuggestionSelected: (Client suggestion) {
                          if (suggestion != null) {
                            _nominalController.text = suggestion.name;
                            helper.clientId = suggestion.id;
                            print(suggestion);
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _buildUpload(),
                    ],
                  ),
                  //Botoes
                  Expanded(
                    child: _buildFooter(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(widget._controller),
    );
  }

  Widget _buildUpload() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            ImageSourceSheet(
                              iconColor: Theme
                                  .of(context)
                                  .primaryColor,
                              onImageSelected: (image) {
                                if (image != null) {
                                  setState(() {
                                    //se tinha uma imagem
                                    if (helper.imageFrontPath != null) {
                                      //apague
                                      File(helper.imageFrontPath).delete();
                                    }
                                    helper.imageFrontPath = image.path;
                                  });
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Foto frente cheque",
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          width: 140,
                          height: 80,
                          color: Colors.transparent,
                          child: helper.imageFrontPath != null
                              ? Image.file(
                            File(helper.imageFrontPath),
                            fit: BoxFit.fill,
                          )
                              : Image.asset(
                            "images/check-teal.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            ImageSourceSheet(
                              iconColor: Theme
                                  .of(context)
                                  .primaryColor,
                              onImageSelected: (image) {
                                if (image != null) {
                                  setState(() {
                                    //se tinha uma imagem
                                    if (helper.imageBackPath != null) {
                                      //apague
                                      File(helper.imageBackPath).delete();
                                    }
                                    helper.imageBackPath = image.path;
                                  });
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Foto verso cheque",
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          width: 140,
                          height: 80,
                          color: Colors.transparent,
                          child: helper.imageBackPath != null
                              ? Image.file(
                            File(helper.imageBackPath),
                            fit: BoxFit.fill,
                          )
                              : Image.asset(
                            "images/check-teal-verso.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.transparent,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildButtonTheme(
            text: "Limpar",
            onPressed: this.helper.cheques.length > 0
                ? () {
              this.helper.clearCheques();
              setState(() {});
            }
                : null,
          ),
          _buildButtonTheme(
            text: "Novo",
            onPressed: this.helper.newCalc,
          ),
          _buildButtonTheme(
            text: "Adicionar",
            onPressed: () {
              this.helper.addCheque();
              setState(() {

              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButtonTheme(
      {@required String text, @required Function() onPressed}) {
    return ButtonTheme(
      height: 50.0,
      minWidth: 100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
        textColor: Colors.white,
        color: Theme
            .of(context)
            .primaryColor,
        onPressed: onPressed,
      ),
    );
  }

  /// Seleciona a data no calendário
  Future _selectDate(TextEditingController controller) async {
    final DateTime now = DateTime.now();
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1, now.month, 1),
      lastDate: DateTime(now.year + 9999, now.month, now.day),
    );
    if (picked != null) {
      setState(() {
        //seta a data no componente
        controller.text = DateUtil.toFormat(picked);

        this.helper.validateDataNCalc();
      });
    }
  }
}
