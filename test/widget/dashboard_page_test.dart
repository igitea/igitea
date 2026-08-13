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

    expect(find.byType(DashboardPage), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('shows my work section with 5 entries', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const DashboardPage()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Issues'), findsWidgets);
    expect(find.text('Pull Requests'), findsWidgets);
    expect(find.text('Top repositories'), findsOneWidget);
    expect(find.text('Organisations'), findsWidgets);
    expect(find.text('Starred Repositories'), findsOneWidget);
  });

  testWidgets('shows favorites and shortcuts sections', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const DashboardPage()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Shortcuts'), findsOneWidget);
    expect(find.text('Mentioned'), findsOneWidget);
    expect(find.text('Review requested'), findsOneWidget);
  });

  testWidgets('shows recent section header', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const DashboardPage()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Recent'), findsOneWidget);
  });
}
