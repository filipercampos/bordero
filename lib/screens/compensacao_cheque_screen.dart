import 'dart:io';

import 'package:bordero/models/cheque.dart';
import 'package:bordero/repository/cheque_repository.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/util/date_util.dart';
import 'package:bordero/util/number_util.dart';
import 'package:flutter/material.dart';

class CompensacaoChequeScreen extends StatefulWidget {
  final Cheque cheque;

  CompensacaoChequeScreen(this.cheque);

  @override
  _CompensacaoChequeScreenState createState() =>
      _CompensacaoChequeScreenState();
}

class _CompensacaoChequeScreenState extends State<CompensacaoChequeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ChequeRepository _repository = RepositoryHelper().chequeRepository;
  final TextEditingController _dataPagamentoController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Compensação"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeader(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //imageCheque
                    _buildAttachment(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Cheque: " +
                                NumberUtil.toFormatBr(
                                    widget.cheque.valorCheque),
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                          Divider(
                            height: 5,
                            color: Colors.grey,
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Taxa: ${NumberUtil.toFormatBr(widget.cheque.taxaJuros)}%",
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Prazo: ${widget.cheque.prazo}",
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Juros: " +
                                        NumberUtil.toFormatBr(
                                            widget.cheque.valorJuros),
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Líquido: " +
                                        NumberUtil.toFormatBr(
                                            widget.cheque.valorLiquido),
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.0, right: 8.0),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: _selectDate,
                    child: IgnorePointer(
                      child: TextField(
                        controller: _dataPagamentoController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).primaryColor,
                          ),
                          border: InputBorder.none,
                          hintText: "Data Compensação",
                          labelText: "Data Compensação",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          contentPadding: EdgeInsets.only(
                              top: 20, right: 20, bottom: 20, left: 5),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.all(16.0),
            child: ButtonTheme(
              height: 50.0,
              minWidth: 120,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "Compensar",
                  style: TextStyle(fontSize: 16),
                ),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: _dataPagamentoController.text.isNotEmpty
                    ? _compensarCheque
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 5.0, 0.0, 5.0),
              child: Text(
                "Cliente: ${widget.cheque.client.name}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }

  Widget _buildAttachment() {
    bool attachment = widget.cheque.imageFrontPath != null;
    DecorationImage decorationImage;
    if (attachment) {
      decorationImage = DecorationImage(
          image: FileImage(
            File(widget.cheque.imageFrontPath),
          ),
          fit: BoxFit.fill);
    } else {
      decorationImage = DecorationImage(
        image: AssetImage("images/check.png"),
        fit: BoxFit.fill,
      );
    }
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 120.0,
      height: 60.0,
      padding: EdgeInsets.zero,
      decoration:
          BoxDecoration(shape: BoxShape.rectangle, image: decorationImage),
    );
  }

  Future<bool> _compensarCheque() async {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          "Compensando cheque ...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );

    Map<String, dynamic> map = {
      "id": widget.cheque.id,
      "dataPagamento": widget.cheque.dataPagamento.millisecondsSinceEpoch
    };
    bool success = await _repository.update(map) > 0;

    //garante a snack bar
    await Future.delayed(Duration(seconds: 1));

    scaffoldKey.currentState.removeCurrentSnackBar();

    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          success ? "Cheque compesado com sucesso" : "Falha ao compesar cheque",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Theme.of(context).primaryColor : Colors.red,
      ),
    );

    if (success) {
      //garante a snack bar
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pop();
    }
    return success;
  }

  /// Seleciona a data no calendário
  Future _selectDate() async {
    final DateTime now = DateTime.now();
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1, now.month, 1),
      lastDate: DateTime(now.year + 9999, now.month, now.day),
    );
    if (picked != null) {
      setState(
        () {
          bool invalido = picked.compareTo(widget.cheque.dataVencimento) <
              0;
          if (invalido) {
            _dataPagamentoController.text = null;
            scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text(
                  "Data de compensação não pode ser inferior a data de vencimento",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }else{
            //seta a data no componente
            _dataPagamentoController.text = DateUtil.toFormat(picked);
            widget.cheque.dataPagamento = picked;
          }
        },
      );
    }
  }
}
