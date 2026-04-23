import 'package:flutter_test/flutter_test.dart';

import 'package:igitea/app.dart';

void main() {
  testWidgets('App renders iGitea text', (WidgetTester tester) async {
    await tester.pumpWidget(const IGiteaApp());
    expect(find.text('iGitea'), findsOneWidget);
  });
}
