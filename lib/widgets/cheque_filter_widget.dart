import 'package:bordero/blocs/cheque_bloc.dart';
import 'package:bordero/util/date_util.dart';
import 'package:flutter/material.dart';

class ChequeFilterWidget extends StatefulWidget {
  final bool _showFilter;
  final ChequeBloc _chequeBloc;

  ChequeFilterWidget(this._showFilter, this._chequeBloc, {Key key})
      : super(key: key);

  @override
  _ChequeFilterWidgetState createState() => _ChequeFilterWidgetState();
}

class _ChequeFilterWidgetState extends State<ChequeFilterWidget> {
  final _dataEmissaoController1 = TextEditingController();
  final _dataEmissaoController2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loaded = false;

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
      return Form(
        key: _formKey,
        child: Container(
          height: 80,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          _selectDate(_dataEmissaoController1, context);
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: _dataEmissaoController1,
                            decoration: InputDecoration(
                              labelText: "De",
                              hintText: "Dt Vencimento",
                              labelStyle: TextStyle(fontSize: 12),
                            ),
                            style: TextStyle(fontSize: 14),
                            keyboardType: TextInputType.datetime,
                            validator: (text) {
                              if (text.isEmpty) {
                                return "Informe a data inicial";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          _selectDate(_dataEmissaoController2,
                              context); // Call Function that has showDatePicker()
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: _dataEmissaoController2,
                            decoration: InputDecoration(
                              labelText: "Até",
                              hintText: "Dt Vencimento",
                              labelStyle: TextStyle(fontSize: 12),
                            ),
                            keyboardType: TextInputType.datetime,
                            style: TextStyle(fontSize: 14),
                            validator: (text) {
                              if (text.isEmpty) {
                                return "Informe a data final";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              var initialValue =
                                  DateUtil.toDate(_dataEmissaoController1.text);
                              var endValue =
                                  DateUtil.toDate(_dataEmissaoController2.text);
                              widget._chequeBloc.getChequesFromDate(
                                initialValue,
                                endValue,
                              );
                              widget._chequeBloc
                                  .getChequesGroupByClientFromDate(
                                initialValue,
                                endValue,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 16,
                          ),
                          onPressed: () {
                            if (loaded == false &&
                                _dataEmissaoController1.text.isNotEmpty &&
                                _dataEmissaoController2.text.isNotEmpty) {
                              widget._chequeBloc.loadCheques();
                              loaded = true;
                            } else {
                              print("clear");
                              loaded = false;
                            }
                            _dataEmissaoController1.text = "";
                            _dataEmissaoController2.text = "";
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
