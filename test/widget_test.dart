import 'package:flutter_test/flutter_test.dart';
import 'package:pitx_mobapp2/features/guest/screens/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('register screen renders the new commuter auth form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

    expect(find.text('Create an account'), findsOneWidget);
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}
