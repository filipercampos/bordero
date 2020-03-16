import 'package:bordero/enums/order_options.dart';
import 'package:flutter/material.dart';

class OrderOptionsPopup extends StatelessWidget {

  final Function(OrderOptions result) orderList;

  OrderOptionsPopup(this.orderList);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<OrderOptions>(
      itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
        const PopupMenuItem<OrderOptions>(
          child: Text("Ordenar A-Z"),
          value: OrderOptions.ASC,
        ),
        const PopupMenuItem<OrderOptions>(
          child: Text("Ordenar Z-A"),
          value: OrderOptions.DESC,
        ),
      ],
      onSelected: orderList,
    );
  }
  
}
