// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bordero/models/client.dart';
import 'package:bordero/repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bordero/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

void mainClient() async {
  ClientRepository rep = ClientRepository();
  Client client = Client.customer(
      "Ciclano", "teste@mail.com", "12345678910", "0000456789", "123456789");

  int id = await rep.insert(client.toJson());
  var clientMap = await rep.get(id);
  var r = Client.fromJson(clientMap);
  print(r);

    var all = await rep.getAll();
  all.forEach((c) => print(Client.fromJson(c)));
}
 