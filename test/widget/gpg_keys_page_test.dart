import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/gpg_keys_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders GPG keys page with app bar', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const GpgKeysPage()));
    await tester.pump();

    expect(find.text('GPG Keys'), findsOneWidget);
  });
}
