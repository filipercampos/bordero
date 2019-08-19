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
        //TODO something with cheque
      },
      onLongPress: () {
        //TODO something
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Cheque: " +
                              NumberUtil.toFormatBr(cheque.valorCheque),
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
            _buildBottom(),

          ],
        ),
      ),
    );
  }

  _buildBottom() {
    if (widget.cheque.client == null) {
      return Column(
        children: <Widget>[
          Divider(height: 1, color: Colors.grey[300],),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Container(
              child: Text(
                "*Atenção: Cheque sem cliente não pode ser salvo",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
            ),
          )
        ],
      );
    }
    return Container();
  }
}
