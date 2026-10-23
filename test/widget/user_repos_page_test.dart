import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/user_repos_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders user repos page', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(const UserReposPage(username: 'testuser')),
    );
    await tester.pump();

    expect(find.byType(FScaffold), findsOneWidget);
  });
}
