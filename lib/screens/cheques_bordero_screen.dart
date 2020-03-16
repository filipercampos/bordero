import 'package:bordero/blocs/cheque_bloc.dart';
import 'package:bordero/helpers/bordero_helper.dart';
import 'package:bordero/models/cheque.dart';
import 'package:bordero/models/client.dart';
import 'package:bordero/screens/client_screen.dart';
import 'package:bordero/screens/home_screen.dart';
import 'package:bordero/screens/widgets/cheque_bordero_tile.dart';
import 'package:bordero/util/number_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

///Cheques calculados
class ChequesBorderoScreen extends StatefulWidget {
  final List<Cheque> cheques;
  final BorderoHelper helper;

  ChequesBorderoScreen(this.cheques, this.helper);

  @override
  _ChequesBorderoScreenState createState() => _ChequesBorderoScreenState();
}

class _ChequesBorderoScreenState extends State<ChequesBorderoScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ChequeBloc _chequeBloc = ChequeBloc();

  BorderoHelper get helper => widget.helper;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //verifica se todos os cheque possuem cliente
    bool blockSave = false;
    double totalJuros = 0.0;
    double totalLiquido = 0.0;
    widget.cheques.forEach((ch) {
      totalJuros += ch.valorJuros;
      totalLiquido += ch.valorCheque;

      //bloquea o salvar
      if (ch.clientId == null || ch.clientId == 0) {
        blockSave = true;
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
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
                onPressed: snapshot.data || blockSave
                    ? null //bloquea o botão se estiver carregando
                    : () async {
                        if (await _saveChequesNBlockScreen()) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
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
              Container(
                margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                child: TypeAheadField<Client>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: helper.nominalController,
                    decoration: InputDecoration(
                      labelText: "Cliente",
                      hintText: "Digite o nome do cliente",
                      labelStyle: TextStyle(fontSize: 12),
                    ),
                    onChanged: (text) {
                      if (helper.client != null) {
                        helper.client = null;
                        helper.nominalController.text = "";
                        helper.cheques.forEach((ch) => ch.setClient(null));
                        setState(() {});
                      }
                    },
                  ),
                  noItemsFoundBuilder: (context) {
                    return GestureDetector(
                      onTap: () async {
                        Client cliente = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClientScreen(),
                          ),
                        );
                        if (cliente != null) {
                          setState(() {
                            helper.client = cliente;
                            helper.client.id = cliente.id;
                            helper.nominalController.text = cliente.name;
                            helper.cheques
                                .forEach((ch) => ch.setClient(cliente));
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(16.0),
                        child: Text(
                            "Cliente não encontrado. Toque para cadastrar"),
                      ),
                    );
                  },
                  suggestionsCallback: (search) async {
                    return await helper.getSuggestions(search);
                  },
                  itemBuilder: (context, Client suggestion) {
                    return Container(
                      height: 50.0,
                      child: ListTile(
                        leading: Icon(Icons.account_box),
                        title: Text(suggestion.name ?? ""),
                        subtitle: Text(suggestion.phone1 ?? ""),
                      ),
                    );
                  },
                  onSuggestionSelected: (Client suggestion) {
                    if (suggestion != null) {
                      setState(() {
                        helper.nominalController.text = suggestion.name;
                        helper.client = suggestion;
                        helper.client.id = suggestion.id;
                        if (helper.cheques.length > 0) {
                          helper.cheques
                              .forEach((ch) => ch.setClient(suggestion));
                        }
                      });
                    }
                  },
                ),
              ),
              Expanded(
                child: ListView.custom(
                  childrenDelegate: SliverChildListDelegate(
                    List.generate(
                      widget.cheques.length,
                      (index) {
                        final item = widget.cheques[index];
                        return Dismissible(
                            key: Key(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString()),
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
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      "Cheque ${item.numeroCheque} removido")));
                            },
                            child: ChequeBorderoTile(item));
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
              ),
            ],
          ),
          //efeito de "congelar a tela"
          StreamBuilder<bool>(
            stream: _chequeBloc.outCreated,
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
    _scaffoldKey.currentState.showSnackBar(
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

    _scaffoldKey.currentState.removeCurrentSnackBar();

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Cheque(s) salvos com sucesso"
              : "Falha ao salvar cheque(s)!",
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
