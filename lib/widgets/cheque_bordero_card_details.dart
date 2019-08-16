import 'package:bordero/models/cheque.dart';
import 'package:bordero/util/number_util.dart';
import 'package:flutter/material.dart';

class ChequeBorderoCardDetails extends StatefulWidget {
  final Cheque cheque;

  ChequeBorderoCardDetails(this.cheque);

  @override
  _ChequeBorderoCardDetailsState createState() => _ChequeBorderoCardDetailsState();
}

class _ChequeBorderoCardDetailsState extends State<ChequeBorderoCardDetails> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    final cheque = widget.cheque;
    return Card(
      child: Row(
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
                "Valor Líquido: ${NumberUtil.toFormatBr(cheque.valorLiquido)}",
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
                  "Taxa %: ${NumberUtil.toFormatBr(cheque.taxaJuros)}",
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
