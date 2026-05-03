import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/repo_stargazers_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders stargazers page with tabs', (tester) async {
    await tester.pumpWidget(buildTestableWidget(
      const RepoStargazersPage(owner: 'testowner', repo: 'testrepo'),
    ));
    await tester.pump();

    expect(find.text('Stargazers'), findsWidgets);
    expect(find.text('Subscribers'), findsWidgets);
  });
}
