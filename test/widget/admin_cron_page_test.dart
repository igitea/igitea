import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/admin_cron_page.dart';
import 'package:igitea/presentation/widgets/forui/app_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders admin cron page', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const AdminCronPage()));
    await tester.pump();

    expect(find.byType(AppPage), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);
  });
}
