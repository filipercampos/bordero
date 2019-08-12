import 'package:bordero/widgets/drawer_tile.dart';
import 'package:flutter/material.dart';

class ChequesTile extends DrawerTile {
  ChequesTile(PageController controller, int pageIndex)
      : super(
            text: "Cheques Calculados",
            icon: Icons.list,
            pageIndex: pageIndex,
            controller: controller);
}
