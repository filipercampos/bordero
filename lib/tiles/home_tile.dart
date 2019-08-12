import 'package:bordero/widgets/drawer_tile.dart';
import 'package:flutter/material.dart';

class HomeTile extends DrawerTile {
  HomeTile(PageController controller, int page)
      : super(
      text: "Home",
      icon: Icons.home,
      pageIndex: page,
      controller: controller);
}
