import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/tag_protections_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders tag protections page with app bar', (tester) async {
    await tester.pumpWidget(buildTestableWidget(
      const TagProtectionsPage(owner: 'testowner', repo: 'testrepo'),
    ));
    await tester.pump();

    expect(find.text('Tag Protections'), findsOneWidget);
  });
}
