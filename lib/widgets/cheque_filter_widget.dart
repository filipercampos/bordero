import 'package:bordero/util/date_util.dart';
import 'package:flutter/material.dart';

class ChequeFilterWidget extends StatefulWidget {
  final bool _showFilter;

  ChequeFilterWidget(this._showFilter, {Key key}) : super(key: key);

  @override
  _ChequeFilterWidgetState createState() => _ChequeFilterWidgetState();
}

class _ChequeFilterWidgetState extends State<ChequeFilterWidget> {
  final _dataEmissaoController = TextEditingController();

  final _dataVencimentoController = TextEditingController();

  buildText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget._showFilter) {
      return Container(
        height: 80,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        _selectDate(_dataEmissaoController, context);
                      },
                      child: IgnorePointer(
                        child: TextFormField(
                          controller: _dataEmissaoController,
                          decoration: InputDecoration(
                            labelText: "Dt Emissão",
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                          keyboardType: TextInputType.datetime,
                          validator: (text) {
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        _selectDate(_dataVencimentoController,
                            context); // Call Function that has showDatePicker()
                      },
                      child: IgnorePointer(
                        child: TextField(
                          controller: _dataVencimentoController,
                          decoration: InputDecoration(
                            labelText: "Dt Vencimento",
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ),
                  ),
                  FlatButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Filtrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      //TODO filter
                    },
                  ),
                  SizedBox(width: 10,),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  /// Seleciona a data no calendário
  Future _selectDate(TextEditingController controller, context) async {
    final DateTime now = DateTime.now();
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1, now.month, 1),
      lastDate: DateTime(now.year + 9999, now.month, now.day),
    );
    if (picked != null) {
      setState(() {
        //seta a data no componente
        controller.text = DateUtil.toFormat(picked);
      });
    }
  }
}
