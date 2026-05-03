import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/follow_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders follow page', (tester) async {
    await tester.pumpWidget(buildTestableWidget(
      const FollowPage(username: 'testuser', type: FollowType.followers),
    ));
    await tester.pump();

    expect(find.text('Followers'), findsOneWidget);
  });
}
