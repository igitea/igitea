import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/notification_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders notification page with app bar', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const NotificationPage()));
    await tester.pump();

    expect(find.text('Notifications'), findsOneWidget);
  });
}
