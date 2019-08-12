import 'package:bordero/datas/cheque.dart';
import 'package:flutter/material.dart';

class ChequesCalculadosScreen extends StatelessWidget {
  final List<Cheque> _cheques;

  ChequesCalculadosScreen(this._cheques);

  @override
  Widget build(BuildContext context) {
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
                  _cheques.length,
                  (index) {
                    var ch = _cheques[index];
                    return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.monetization_on,
                              size: 64,
                            ),
                            height: 80,
                            width: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Valor Cheque"),
                                Text("Valor Juros"),
                                Text("Prazo"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: <Widget>[
                                Text(ch.valorCheque.toStringAsFixed(2)),
                                Text(ch.valorJuros.toStringAsFixed(2)),
                                Text(ch.prazoTotal.toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          //footer
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("TOTAL JUROS:"),
                Text("0.00"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("TOTAL JUROS:"),
                Text("0.00"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
