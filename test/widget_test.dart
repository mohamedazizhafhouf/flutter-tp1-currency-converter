// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_converter/main.dart';

void main() {
  testWidgets('converts between dinars and euros', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), '3.4');
    await tester.tap(find.text('Dinar -> Euro'));
    await tester.pump();

    expect(find.text('3.40 TND = 1.00 EUR'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '2');
    await tester.tap(find.text('Euro -> Dinar'));
    await tester.pump();

    expect(find.text('2.00 EUR = 6.80 TND'), findsOneWidget);
  });
}
