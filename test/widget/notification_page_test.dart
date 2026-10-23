import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/notification_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders content without a nested app bar', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const NotificationPage()));
    await tester.pump();

    expect(find.byType(NotificationPage), findsOneWidget);
    // The shell in HomePage owns the only header, so the tab must not add one.
    expect(find.byType(AppBar), findsNothing);
  });
}
