
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///Elemento da barra lateral flutuante
abstract class DrawerTile extends StatelessWidget {
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
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16.0),
              height: 30,
              child: Row(
                children: <Widget>[
                  //define a cor do item selecionado para o tema atual
                  Icon(icon, size: 32, color: color()),
                  //item do menu de navegação da página
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        text,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: color()),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 32,
                    color: color(),
                  )
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
