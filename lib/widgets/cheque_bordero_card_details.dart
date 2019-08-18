import 'package:bordero/models/cheque.dart';
import 'package:bordero/util/number_util.dart';
import 'package:flutter/material.dart';

class ChequeBorderoCardDetails extends StatefulWidget {
  final Cheque cheque;

  ChequeBorderoCardDetails(this.cheque);

  @override
  _ChequeBorderoCardDetailsState createState() =>
      _ChequeBorderoCardDetailsState();
}

class _ChequeBorderoCardDetailsState extends State<ChequeBorderoCardDetails> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final cheque = widget.cheque;
    return InkWell(
      onTap: () {
        //TODO something wit cheque
      },
      onLongPress: () {
        //TODO something
      },
      child: Card(
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
                Column(
                  children: <Widget>[
                    Text(
                      "Cheque: " + NumberUtil.toFormatBr(cheque.valorCheque),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
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
          ],
        ),
      ),
    );
  }
}
