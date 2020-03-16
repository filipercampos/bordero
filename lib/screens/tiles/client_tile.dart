import 'package:bordero/screens/widgets/drawer_tile.dart';
import 'package:flutter/material.dart';

class ClientTile extends DrawerTile {
  ClientTile(PageController controller,int pageIndex)
      : super(
      text: "Clientes",
      icon: Icons.group,
      pageIndex: pageIndex,
      controller: controller);
}
