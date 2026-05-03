import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/dashboard_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders dashboard page', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const DashboardPage()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
