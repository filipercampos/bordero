import 'package:bordero/screens/widgets/drawer_tile.dart';
import 'package:flutter/material.dart';

class ChequesTile extends DrawerTile {
  ChequesTile(PageController controller, int pageIndex)
      : super(
            text: "Cheques",
            icon: Icons.account_balance,
            pageIndex: pageIndex,
            controller: controller);
}
