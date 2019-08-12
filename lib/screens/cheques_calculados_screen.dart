import 'package:bordero/helpers/cheque_helper.dart';
import 'package:bordero/util/number_util.dart';
import 'package:bordero/widgets/cheque_card.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class ChequesCalculadosScreen extends StatefulWidget {
  final List<Cheque> cheques;

  ChequesCalculadosScreen(this.cheques);

  @override
  _ChequesCalculadosScreenState createState() =>
      _ChequesCalculadosScreenState();
}

class _ChequesCalculadosScreenState extends State<ChequesCalculadosScreen> {
  @override
  Widget build(BuildContext context) {
    Decimal totalJuros = Decimal.parse("0");
    Decimal totalLiquido = Decimal.parse("0");
    widget.cheques.forEach((ch) {
      totalJuros += ch.valorJuros;
      totalLiquido += ch.valorCheque;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Cheques Calculados"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.custom(
              childrenDelegate: SliverChildListDelegate(
                List.generate(
                  widget.cheques.length,
                  (index) {
                    final item = widget.cheques[index];
                    return Dismissible(
                      key:
                          Key(DateTime.now().millisecondsSinceEpoch.toString()),
                      direction: DismissDirection.endToStart,
                      // Show a red background as the item is swiped away.
                      background: Container(
                        color: Colors.red,
                        //distancia da esquerda pra direita
                        child: Container(
                          margin: EdgeInsets.only(right: 32),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          widget.cheques.removeAt(index);
                        });
                        // Then show a snackbar.
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Cheque ${item.numeroCheque} removido")));
                      },
                      child: ChequeCard(item),
                    );
                  },
                ),
              ),
            ),
          ),
          //footer
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "TOTAL LÍQUIDO:",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                Text(
                  NumberUtil.toFormatBr(totalLiquido),
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "TOTAL JUROS:",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                Text(
                  NumberUtil.toFormatBr(totalJuros),
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
