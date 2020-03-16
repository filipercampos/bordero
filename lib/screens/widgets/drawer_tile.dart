
import 'package:flutter/material.dart';

///Widget lateral flutuante
class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController controller;
  final int pageIndex;

  DrawerTile(
      {@required this.icon,
        @required this.text,
        @required this.controller,
        @required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return _buildMaterial(context);
  }

  Widget _buildMaterial(context) {

//mudar a cor da tupla quando selecionada
    Color color() {
      return controller.page.round() == pageIndex
          ? Theme.of(context).primaryColor
          : Colors.grey[600];
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(); //fecha o drawer
          controller.jumpToPage(pageIndex);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              //reduz o tamanho do tile
              dense: true,
              //nao posso alterar o padding from bottom or top
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              leading: Icon(icon, size: 32, color: color()),
              title: Text(
                text,
                style: TextStyle(color: color()),
              ),
              trailing: Icon(Icons.keyboard_arrow_right,color: color()),
              onTap: () {
                Navigator.of(context).pop(); //fecha o drawer
                controller.jumpToPage(pageIndex);
              },
            ),
          ],
        ),
      ),
    );
  }
}