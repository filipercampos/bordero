import 'package:bordero/blocs/cheque_bloc.dart';
import 'package:bordero/models/cheque.dart';
import 'package:bordero/screens/home_screen.dart';
import 'package:bordero/util/number_util.dart';
import 'package:bordero/widgets/cheque_card.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

///Cheques calculados
class ChequesCalculadosScreen extends StatefulWidget {
  final List<Cheque> cheques;

  ChequesCalculadosScreen(this.cheques);

  @override
  _ChequesCalculadosScreenState createState() =>
      _ChequesCalculadosScreenState();
}

class _ChequesCalculadosScreenState extends State<ChequesCalculadosScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ChequeBloc _chequeBloc = ChequeBloc();
  @override
  Widget build(BuildContext context) {
    Decimal totalJuros = Decimal.zero;
    Decimal totalLiquido = Decimal.zero;
    widget.cheques.forEach((ch) {
      totalJuros += ch.valorJuros;
      totalLiquido += ch.valorCheque;
    });

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Cheques Calculados"),
        centerTitle: true,
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _chequeBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(
                  Icons.save,
                ),
                onPressed: snapshot.data
                    ? null
                    : () async {
                        if (await _saveChequesNBlockScreen()) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => HomeScreen())
                          );
                        }
                      },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Expanded(
                child: ListView.custom(
                  childrenDelegate: SliverChildListDelegate(
                    List.generate(
                      widget.cheques.length,
                      (index) {
                        final item = widget.cheques[index];
                        return Dismissible(
                          key: Key(
                              DateTime.now().millisecondsSinceEpoch.toString()),
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
                                content: Text(
                                    "Cheque ${item.numeroCheque} removido")));
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
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Text(
                      NumberUtil.toFormatBr(totalLiquido),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Text(
                      NumberUtil.toFormatBr(totalJuros),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ],
                ),
              )
            ],
          ),
          //efeito de "congelar a tela"
          StreamBuilder<bool>(
            stream: _chequeBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IgnorePointer(
                ignoring: !snapshot.data,
                child: Container(
                  color: snapshot.data ? Colors.black54 : Colors.transparent,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _saveChequesNBlockScreen() async {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          "Salvando cheques ...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );

    bool success = await _chequeBloc.saveCheques(widget.cheques);
    //garante a snack bar 
    await Future.delayed(Duration(seconds: 1));

    scaffoldKey.currentState.removeCurrentSnackBar();

    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          success ? "Cheque(s) salvos !" : "Falha ao salvar cheque(s)!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Theme.of(context).primaryColor : Colors.red,
      ),
    );
    //garante a snack bar 
    await Future.delayed(Duration(seconds: 1));
    return success;
  }
}
