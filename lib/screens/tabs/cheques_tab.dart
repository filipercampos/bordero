import 'package:bordero/blocs/cheque_bloc.dart';
import 'package:bordero/enums/cheque_view_type.dart';
import 'package:bordero/models/cheque.dart';
import 'package:bordero/preferences/shared_preferences_bordero.dart';
import 'package:bordero/screens/compensacao_cheque_screen.dart';
import 'package:bordero/util/animation_util.dart';
import 'package:bordero/util/number_util.dart';
import 'package:bordero/screens/widgets/cheque_bordero_card_details.dart';
import 'package:bordero/screens/widgets/cheque_client_tile.dart';
import 'package:bordero/screens/widgets/cheque_filter_widget.dart';
import 'package:bordero/screens/widgets/cheque_simple_tile.dart';
import 'package:bordero/screens/widgets/custom_drawer.dart';
import 'package:bordero/enums/sort_criteria_cheque.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ChequesTab extends StatefulWidget {
  final PageController _controller;

  ChequesTab(this._controller);

  @override
  _ChequesTabState createState() => _ChequesTabState();
}

class _ChequesTabState extends State<ChequesTab> {
  final _chequeBloc = ChequeBloc();
  bool _showFilter = false;
  final preferences = SharedPreferenceBordero();
  ChequeViewType _selectedView;

  @override
  void initState() {
    super.initState();
    _chequeBloc.loadCheques();
    preferences.setViewCheques(ChequeViewType.CHEQUES_BY_CLIENT);
    setState(() {});

    _init();
  }

  void _init() async {
    _selectedView = await preferences.getViewCheques();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingButton(),
      appBar: AppBar(
        title: Text("Cheques"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilter = _showFilter == true ? false : true;
              });
            },
          ),
          PopupMenuButton<ChequeViewType>(
            itemBuilder: (context) => <PopupMenuEntry<ChequeViewType>>[
              const PopupMenuItem(
                child: ListTile(
                  title: Text(
                    "Cheques/Cliente",
                    style: TextStyle(fontSize: 12),
                  ),
                  leading: Icon(Icons.view_list, color: Colors.teal),
                ),
                value: ChequeViewType.CHEQUES,
              ),
              const PopupMenuItem(
                child: ListTile(
                  title: Text(
                    "Cheques",
                    style: TextStyle(fontSize: 12),
                  ),
                  leading: Icon(Icons.view_quilt, color: Colors.teal),
                ),
                value: ChequeViewType.CHEQUES_DETAILS,
              ),
              const PopupMenuItem(
                child: ListTile(
                  title: Text(
                    "Agrupados",
                    style: TextStyle(fontSize: 12),
                  ),
                  leading: Icon(Icons.group, color: Colors.teal),
                ),
                value: ChequeViewType.CHEQUES_BY_CLIENT,
              ),
            ],
            onSelected: _onSelectedView,
          ),
        ],
      ),
      drawer: CustomDrawer(widget._controller),
      body: Container(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                _buildFilter(),
                Expanded(
                  child: StreamBuilder<List<Cheque>>(
                      stream: _chequeBloc.outCheques,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return _buildShimmerEffect();
                        } else if (snapshot.data.length == 0) {
                          return Center(
                              child: Text(
                            "Nenhum resultado",
                            style: TextStyle(color: Colors.grey),
                          ));
                        }
                        return StreamBuilder<bool>(
                            stream: _chequeBloc.outChequeViewType,
                            initialData: false,
                            builder: (context, snapshotView) {
                              return _buildViews(snapshot);
                            });
                      }),
                ),
                StreamBuilder<List<Cheque>>(
                  stream: _chequeBloc.outCheques,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _buildFooter(snapshot);
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilter() {
    if (_showFilter) {
      return ChequeFilterWidget(_showFilter, _chequeBloc);
    } else {
      return Container();
    }
  }

  Widget _buildFloatingButton() {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.only(bottom: 50.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: primaryColor,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(Icons.arrow_downward, color: Colors.white),
                backgroundColor: primaryColor,
                label: _selectedView != ChequeViewType.CHEQUES_BY_CLIENT
                    ? "Maior Vencimento"
                    : "Cliente A-Z",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _chequeBloc.setOrderCriteria(SortCriteriaCheque.HIGH_VALUE);
                }),
            SpeedDialChild(
                child: Icon(Icons.arrow_upward, color: Colors.white),
                backgroundColor: primaryColor,
                label: _selectedView != ChequeViewType.CHEQUES_BY_CLIENT
                    ? "Menor Vencimento"
                    : "Cliente Z-A",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _chequeBloc.setOrderCriteria(SortCriteriaCheque.LOW_VALUE);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      padding: EdgeInsets.all(4.0),
      itemCount: 10,
      itemBuilder: (context, index) {
        return AnimationUtil.buildCardShimmerEffect(context);
      },
    );
  }

  void _onSelectedView(ChequeViewType value) {
    this._selectedView = value;
    this._chequeBloc.repaintView(value);
  }

  Widget _buildViews(snapshot) {
    Widget view;
    switch (_selectedView) {
      case ChequeViewType.CHEQUES:
        //view 1 card simple
        view = ListView.builder(
          padding: EdgeInsets.all(4.0),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                //compensacao
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        CompensacaoChequeScreen(snapshot.data[index]),
                  ),
                );
              },
              child: ChequeSimpleTile(snapshot.data[index]),
            );
          },
        );
        break;
      case ChequeViewType.CHEQUES_DETAILS:
        //view 1 card details
        view = ListView.builder(
          padding: EdgeInsets.all(4.0),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                //compensacao
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CompensacaoChequeScreen(snapshot.data[index])));
              },
              child: ChequeBorderoCardDetails(
                snapshot.data[index],
              ),
            );
          },
        );
        break;
      case ChequeViewType.CHEQUES_BY_CLIENT:
        //view 1 card group client
        view = ChequeClientTile(_chequeBloc);
        break;
    }
    return view;
  }

  Widget _buildFooter(snapshot) {
    //verifica se todos os cheque possuem cliente
    double totalJuros = 0.0;
    double totalLiquido = 0.0;

    var data = _selectedView != ChequeViewType.CHEQUES_BY_CLIENT
        ? snapshot.data
        : _chequeBloc.chequesClient;

    data.forEach((ch) {
      totalJuros += ch.valorJuros;
      totalLiquido += ch.valorCheque;
    });

    return Column(
      children: [
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
        ),
      ],
    );
  }
}
