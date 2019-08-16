import 'package:bordero/models/cheque.dart';
import 'package:bordero/repository/cheque_repository.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/widgets/cheque_bordero_card_details.dart';
import 'package:bordero/widgets/cheque_simple_card.dart';
import 'package:bordero/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class ChequesTab extends StatefulWidget {

  final PageController _controller ;

  ChequesTab(this._controller);

  @override
  _ChequesTabState createState() => _ChequesTabState();
}

class _ChequesTabState extends State<ChequesTab> {
  ChequeRepository _repository = RepositoryHelper().chequeRepository;
  List<Cheque> cheques = List<Cheque>();

  @override
  void initState() {
    super.initState();

    _repository.getAll().then((list) {
      setState(() {
        list.forEach((map) => cheques.add(Cheque.fromJson(map)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    return Column(
//      children: [
//        Expanded(
//          child: ListView.custom(
//            childrenDelegate: SliverChildListDelegate(
//              List.generate(
//                cheques.length,
//                    (index) {
//                  return ChequeBorderoCardDetails(cheques[index]);
//                },
//              ),
//            ),
//          ),
//        ),
//      ],
//    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cheques"),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.list),
              ),
              Tab(
                icon: Icon(Icons.view_quilt),
              ),
            ],
          ),
        ),
        drawer: CustomDrawer(widget._controller),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(), //desativa o slide
          children: <Widget>[
            //view 1 card simple
            ListView.builder(
              padding: EdgeInsets.all(4.0),
              itemCount: cheques.length,
              itemBuilder: (context, index) {
                return ChequeSimpleCard(cheques[index]);
              },
            ),
            //view 1 card details
            ListView.builder(
              padding: EdgeInsets.all(4.0),
              itemCount: cheques.length,
              itemBuilder: (context, index) {
                return ChequeBorderoCardDetails(cheques[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}