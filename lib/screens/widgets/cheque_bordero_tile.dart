import 'package:bordero/models/cheque.dart';
import 'package:bordero/util/date_util.dart';
import 'package:bordero/util/number_util.dart';
import 'package:flutter/material.dart';

class ChequeBorderoTile extends StatefulWidget {
  final Cheque cheque;

  ChequeBorderoTile(this.cheque);

  @override
  _ChequeBorderoTileState createState() => _ChequeBorderoTileState();
}

class _ChequeBorderoTileState extends State<ChequeBorderoTile> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final cheque = widget.cheque;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context, cheque),
          Row(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.monetization_on,
                  size: 48,
                  color: primaryColor,
                ),
                height: 80,
                width: 80,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Cheque: " +
                                  NumberUtil.toFormatBr(cheque.valorCheque),
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(right: 12.0),
                            alignment: Alignment.topRight,
                            child: cheque.clientId == null
                                ? Icon(
                                    Icons.error,
                                    color: Colors.red[900],
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Juros: ${NumberUtil.toFormatBr(cheque.valorJuros)}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Líquido: ${NumberUtil.toFormatBr(cheque.valorLiquido)}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Prazo: ${cheque.prazoTotal.toString()}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Taxa %: ${NumberUtil.toFormatBr(cheque.taxaJuros)}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildBottom(),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    if (widget.cheque.client == null && widget.cheque.id == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            height: 1,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
            child: Container(
              child: Text(
                "*Atenção: Informe o cliente para salvar o(s) cheque(s)",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      );
    }
    return Container();
  }

  Widget _buildHeader(context, Cheque cheque) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 5.0, 0.0, 5.0),
              child: Text(
                "Emissão: ${DateUtil.toFormat(cheque.dataEmissao)}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 8.0, 5.0),
              child: Text(
                "Vencimento: ${DateUtil.toFormat(cheque.dataVencimento)}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: cheque.dataPagamento == null
                      ? cheque.dataVencimento.isBefore(DateUtil.toDateZero())
                          ? Colors.blue[500]
                          : Colors.red[800]
                      : Theme.of(context).primaryColor,
                ),
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
}
