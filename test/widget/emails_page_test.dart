import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/emails_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders emails page with app bar', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const EmailsPage()));
    await tester.pump();

    expect(find.text('Email Addresses'), findsOneWidget);
  });
}
