import 'package:bordero/blocs/cheque_bloc.dart';
import 'package:bordero/models/cheque.dart';
import 'package:bordero/util/animation_util.dart';
import 'package:bordero/widgets/cheque_bordero_card_details.dart';
import 'package:bordero/widgets/cheque_client_card.dart';
import 'package:bordero/widgets/cheque_filter_widget.dart';
import 'package:bordero/widgets/cheque_simple_card.dart';
import 'package:bordero/widgets/custom_drawer.dart';
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

  @override
  void initState() {
    super.initState();
    _chequeBloc.loadCheques();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: _buildFloatingButton(),
          appBar: AppBar(
            title: Text("Cheques"),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.view_list),
                ),
                Tab(
                  icon: Icon(Icons.view_quilt),
                ),
                Tab(
                  icon: Icon(Icons.group),
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  setState(() {
                    _showFilter = !_showFilter;
                  });
                },
              )
            ],
          ),
          drawer: CustomDrawer(widget._controller),
          body: StreamBuilder<List<Cheque>>(
            stream: _chequeBloc.outCheques,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _buildShimmerEffect();
              } else if (snapshot.data.length == 0) {
                return Center(child: Text("Nenhum resultado"));
              }
              if (_showFilter) {
                return ChequeFilterWidget(_showFilter);
              }
              return TabBarView(
                physics: NeverScrollableScrollPhysics(), //desativa o slide
                children: <Widget>[
                  //view 1 card simple
                  ListView.builder(
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ChequeSimpleCard(snapshot.data[index]);
                    },
                  ),
                  //view 1 card details
                  ListView.builder(
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ChequeBorderoCardDetails(snapshot.data[index]);
                    },
                  ),
                  //view 1 card group client
                  ChequeClientCard(_chequeBloc),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButton() {
    final primaryColor = Theme.of(context).primaryColor;
    return SpeedDial(
      child: Icon(Icons.sort),
      backgroundColor: primaryColor,
      overlayOpacity: 0.4,
      overlayColor: Colors.black,
      children: [
        SpeedDialChild(
            child: Icon(Icons.arrow_downward, color: primaryColor),
            backgroundColor: Colors.white,
            label: "Maior Cheque",
            labelStyle: TextStyle(fontSize: 14),
            onTap: () {
              _chequeBloc.setOrderCriteria(SortCriteriaCheque.HIGH_VALUE);
            }),
        SpeedDialChild(
            child: Icon(Icons.arrow_upward, color: primaryColor),
            backgroundColor: Colors.white,
            label: "Menor Cheque",
            labelStyle: TextStyle(fontSize: 14),
            onTap: () {
              _chequeBloc.setOrderCriteria(SortCriteriaCheque.LOW_VALUE);
            }),
      ],
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
}
