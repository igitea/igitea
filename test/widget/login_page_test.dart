import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/login_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  Widget testWidget() {
    return buildTestableWidget(const LoginPage());
  }

  group('LoginPage', () {
    testWidgets('renders iGitea title and subtitle', (tester) async {
      await tester.pumpWidget(testWidget());
      await tester.pump();
      expect(find.text('iGitea'), findsOneWidget);
      expect(find.text('Connect to your Gitea instance'), findsOneWidget);
    });

    testWidgets('shows the three login modes', (tester) async {
      await tester.pumpWidget(testWidget());
      await tester.pump();
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Token'), findsOneWidget);
      expect(find.text('OAuth2'), findsOneWidget);
    });

    testWidgets('account mode shows server URL, username and password', (
      tester,
    ) async {
      await tester.pumpWidget(testWidget());
      await tester.pump();
      expect(find.text('Server URL'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(EditableText), findsNWidgets(3));
    });

    testWidgets('token mode shows the token form', (tester) async {
      await tester.pumpWidget(testWidget());
      await tester.pump();

      await tester.tap(find.text('Token'));
      await tester.pumpAndSettle();

      expect(find.text('Sign In with Token'), findsOneWidget);
      expect(find.byType(EditableText), findsNWidgets(2));
    });

    testWidgets('password field is obscured by default', (tester) async {
      await tester.pumpWidget(testWidget());
      await tester.pump();

      final password = tester.widget<EditableText>(
        find.byType(EditableText).at(2),
      );
      expect(password.obscureText, isTrue);
    });

    testWidgets('validation errors show when submitting empty account form', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(testWidget());
      await tester.pump();

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a server URL'), findsOneWidget);
      expect(find.text('Please enter your username'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('server URL validation rejects invalid URLs', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(testWidget());
      await tester.pump();

      await tester.enterText(find.byType(EditableText).first, 'not-a-url');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid URL'), findsOneWidget);
    });
  });
}
