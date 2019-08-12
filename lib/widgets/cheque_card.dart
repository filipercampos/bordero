import 'package:bordero/helpers/cheque_helper.dart';
import 'package:bordero/util/number_util.dart';
import 'package:flutter/material.dart';

class ChequeCard extends StatefulWidget {
  final Cheque cheque;

  ChequeCard(this.cheque);

  @override
  _ChequeCardState createState() => _ChequeCardState();
}

class _ChequeCardState extends State<ChequeCard> {
  @override
  Widget build(BuildContext context) {
    final cheque = widget.cheque;
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            child: Icon(
              Icons.monetization_on,
              size: 48,
              color: Colors.teal,
            ),
            height: 80,
            width: 80,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Valor Cheque: ${NumberUtil.toFormatBr(cheque.valorCheque)}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Valor Juros: ${NumberUtil.toFormatBr(cheque.valorJuros)}",
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Valor Líquido: ${NumberUtil.toFormatBr(cheque.valorCheque)}",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(""),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Prazo: ${cheque.prazoTotal.toString()}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Taxa %: ${cheque.taxaJuros.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
