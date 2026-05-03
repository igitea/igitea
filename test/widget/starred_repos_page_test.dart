import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/starred_repos_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders starred repos page with app bar', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const StarredReposPage()));
    await tester.pump();

    expect(find.text('Starred Repositories'), findsOneWidget);
  });
}
