import 'package:bordero/screens/bordero_screen.dart';
import 'package:flutter/material.dart';

class BorderoButton extends StatelessWidget {
  final PageController controller ;

  BorderoButton(this.controller);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      onPressed: () {
        //salte para o calculador
        controller.jumpToPage(1);
      },
    );
  }
}
