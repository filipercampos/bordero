import 'package:bordero/models/cheque.dart';
import 'package:bordero/repository/cheque_repository.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/util/date_util.dart';
import 'package:bordero/util/number_util.dart';
import 'package:carousel_pro/carousel_pro.dart';
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
  final List<dynamic> imagens = List<dynamic>();
  Cheque cheque;

  @override
  void initState() {
    super.initState();
    this.cheque = Cheque.clone(widget.cheque);
    if (this.cheque.imageFrontPath != null) {
      this.imagens.add(this.cheque.imageFrontPath);
    }
    if (this.cheque.imageBackPath != null) {
      this.imagens.add(this.cheque.imageBackPath);
    }
    if (this.cheque.dataPagamento != null) {
      _dataPagamentoController.text =
          DateUtil.toFormat(this.cheque.dataPagamento);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Compensação"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: Container(
              margin: EdgeInsets.fromLTRB(12.0, 0.0, 8.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildHeader(context),
                  Divider(
                    height: 5,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _buildText("Vencimento: " +
                                  DateUtil.toFormat(
                                      this.cheque.dataVencimento)),
                              _buildText(
                                  "Taxa: ${NumberUtil.toFormatBr(this.cheque.taxaJuros)}%"),
                              _buildText("Prazo: ${this.cheque.prazo}"),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _buildText(
                                "Emissão: ${DateUtil.toFormat(this.cheque.dataEmissao)}",
                              ),
                              _buildText(
                                "Juros: " +
                                    NumberUtil.toFormatBr(
                                        this.cheque.valorJuros),
                              ),
                              _buildText(
                                "Líquido: " +
                                    NumberUtil.toFormatBr(
                                        this.cheque.valorLiquido),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: widget.cheque.dataPagamento == null
                          ? _selectDate
                          : null,
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
                            labelText: widget.cheque.dataPagamento == null
                                ? "Data Compensação"
                                : "Cheque Compensado",
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
          ),
          Container(
            height: 260.0,
            width: 260.0,
            padding: EdgeInsets.all(16.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Carousel(
                images: imagens.map((url) {
                  return AssetImage(url);
                }).toList(),
                dotSize: 4.0,
                //tamanho do ponto da imagem selecionada
                dotSpacing: 15.0,
                //espacamento entre os pontos
                dotBgColor: Colors.transparent,
                dotColor: Colors.white,
                autoplay: false, //desativa a rolagem de imagens auto
              ),
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
                onPressed: _dataPagamentoController.text.isNotEmpty &&
                        this.cheque.dataPagamento == null
                    ? _compensarCheque
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, top: 4.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }

  Widget _buildHeader(context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        child: Text(
          "Cliente: ${this.cheque.client.name}",
          overflow: TextOverflow.clip,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      trailing: Text(
        NumberUtil.toFormatBr(this.cheque.valorCheque),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
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
    var dataPagamento = DateUtil.toDate(_dataPagamentoController.text);
    Map<String, dynamic> map = {
      "id": this.cheque.id,
      "dataPagamento": dataPagamento.millisecondsSinceEpoch
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
      this.cheque.dataPagamento = dataPagamento;
      setState(() {

      });
      //garante a snack bar
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pop(this.cheque);
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
          bool invalido = picked.compareTo(this.cheque.dataEmissao) < 0;
          if (invalido) {
            _dataPagamentoController.text = null;
            scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text(
                  "Data de compensação não pode ser inferior a data de emissão",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            //seta a data no componente
            _dataPagamentoController.text = DateUtil.toFormat(picked);
          }
        },
      );
    }
  }
}
