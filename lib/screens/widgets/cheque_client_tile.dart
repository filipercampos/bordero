import 'package:bordero/blocs/cheque_bloc.dart';
import 'package:bordero/models/cheque_client.dart';
import 'package:bordero/util/animation_util.dart';
import 'package:bordero/util/number_util.dart';
import 'package:flutter/material.dart';

class ChequeClientTile extends StatelessWidget {
  final ChequeBloc _chequeBloc;
  ChequeClientTile(this._chequeBloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChequeClient>>(
        stream: _chequeBloc.outChequesClient,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(4.0),
              itemCount: 10,
              itemBuilder: (context, index) {
                return AnimationUtil.buildCardShimmerEffect(context);
              },
            );
          }  else if (snapshot.data.length == 0) {
            return Center(child: Text("Nenhum resultado"));
          }

          return ListView.builder(
            padding: EdgeInsets.all(4.0),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              ChequeClient chclient = snapshot.data[index];

              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildHeader(chclient),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //ilustração do cheque
                        Container(
                          margin: EdgeInsets.all(8.0),
                          width: 120.0,
                          height: 60.0,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: AssetImage("assets/images/check.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Cheque: " +
                                    NumberUtil.toDoubleFormatBr(
                                        chclient.valorCheque),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Divider(
                                height: 5,
                                color: Colors.grey,
                              ),
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Taxa: ${NumberUtil.toDoubleFormatBr(chclient.taxaJuros)}%",
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Prazo: ${chclient.prazo}",
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Juros: " +
                                            NumberUtil.toDoubleFormatBr(
                                                chclient.valorJuros),
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Líquido: " +
                                            NumberUtil.toDoubleFormatBr(
                                                chclient.valorLiquido),
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
              );
            },
          );
        });
  }

  Widget _buildHeader(ChequeClient chequeClient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(8.0, 5.0, 0.0, 5.0),
          child: Text(
            "Cliente: ${chequeClient.clientName}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}
