import 'package:bordero/widgets/drawer_tile.dart';
import 'package:flutter/material.dart';

class BorderoTile extends DrawerTile {
  BorderoTile(PageController controller,int pageIndex)
      : super(
            text: "Calculador Cheque",
            icon: Icons.monetization_on,
            pageIndex: pageIndex,
            controller: controller);
}