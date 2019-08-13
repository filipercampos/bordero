import 'package:flutter/material.dart';

class ChequesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.custom(
            childrenDelegate: SliverChildListDelegate(
              List.generate(
                5,
                (index) {
                  return Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(1.0),
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: ListTile(
                            leading: const Icon(Icons.monetization_on,
                                size: 40.0, color: Colors.grey),
                            title: Text('Valor Cheque: $index'),
                            subtitle: Text('Juros: $index'),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
