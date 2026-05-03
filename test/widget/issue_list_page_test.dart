import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/issue_list_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders issue list with app bar', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const IssueListPage()));
    await tester.pump();

    expect(find.text('Issues'), findsOneWidget);
  });
}
