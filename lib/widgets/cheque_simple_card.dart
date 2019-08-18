import 'dart:io';

import 'package:bordero/models/cheque.dart';
import 'package:bordero/util/number_util.dart';
import 'package:flutter/material.dart';

class ChequeSimpleCard extends StatelessWidget {
  final Cheque cheque;

  ChequeSimpleCard(this.cheque);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //TODO something wit cheque
      },
      onLongPress: () {
        //TODO something
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHead(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //imageCheque
                _buildAttachment(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Cheque: " + NumberUtil.toFormatBr(cheque.valorCheque),
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        height: 5,
                        color: Colors.grey,
                      ),
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Taxa: ${NumberUtil.toFormatBr(cheque.taxaJuros)}%",
                                style: TextStyle(fontSize: 12.0),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Prazo: ${cheque.prazo}",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Juros: " +
                                    NumberUtil.toFormatBr(cheque.valorJuros),
                                style: TextStyle(fontSize: 12.0),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Líquido: " +
                                    NumberUtil.toFormatBr(cheque.valorLiquido),
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHead() {
    if (cheque.nominal != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(8.0, 5.0, 0.0, 5.0),
            child: Text(
              "Cliente: ${cheque.nominal}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildAttachment() {
    bool attachment = cheque.imagePath != null;
    DecorationImage decorationImage;
    if (attachment) {
      decorationImage = DecorationImage(
          image: FileImage(
            File(cheque.imagePath),
          ),
          fit: BoxFit.fill);
    } else {
      decorationImage = DecorationImage(
        image: AssetImage("images/check.png"),
        fit: BoxFit.fill,
      );
    }
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 120.0,
      height: 60.0,
      padding: EdgeInsets.zero,
      decoration:
          BoxDecoration(shape: BoxShape.rectangle, image: decorationImage),
    );
  }
}
