import 'dart:io';

import 'package:bordero/models/cheque.dart';
import 'package:bordero/util/number_util.dart';
import 'package:flutter/material.dart';

class ChequeSimpleCard extends StatelessWidget {
  final Cheque cheque;

  ChequeSimpleCard(this.cheque);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 150.0,
              height: 70.0,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: cheque.imagePath != null
                        ? FileImage(File(cheque.imagePath))
                        : AssetImage("images/check.png"),
                    fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Cheque: " + NumberUtil.toFormatBr(cheque.valorCheque),
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Taxa: ${NumberUtil.toFormatBr(cheque.taxaJuros)} %",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    "Juros: " + NumberUtil.toFormatBr(cheque.valorJuros),
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        //TODO something wit cheque
      },
    );
  }
}
