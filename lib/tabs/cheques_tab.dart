import 'package:bordero/models/cheque.dart';
import 'package:bordero/repository/cheque_repository.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:bordero/widgets/cheque_card.dart';
import 'package:flutter/material.dart';

class ChequesPage extends StatefulWidget {
  @override
  _ChequesPageState createState() => _ChequesPageState();
}

class _ChequesPageState extends State<ChequesPage> {
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
    return Column(
      children: [
        Expanded(
          child: ListView.custom(
            childrenDelegate: SliverChildListDelegate(
              List.generate(
                cheques.length,
                (index) {
                  return ChequeCard(cheques[index]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
