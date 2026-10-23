import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/admin_runners_page.dart';
import 'package:igitea/presentation/widgets/forui/app_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders admin runners page', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const AdminRunnersPage()));
    await tester.pump();

    expect(find.byType(AppPage), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);
  });
}
