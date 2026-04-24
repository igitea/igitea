import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/login_page.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  Widget testWidget() {
    return const MaterialApp(home: LoginPage());
  }

  group('LoginPage', () {
    testWidgets('renders iGitea title and subtitle', (tester) async {
      await tester.pumpWidget(testWidget());
      expect(find.text('iGitea'), findsOneWidget);
      expect(find.text('Connect to your Gitea instance'), findsOneWidget);
    });

    testWidgets('shows both login tabs', (tester) async {
      await tester.pumpWidget(testWidget());
      expect(find.text('Username & Password'), findsOneWidget);
      expect(find.text('Access Token'), findsWidgets);
    });

    testWidgets(
      'basic auth tab shows Server URL, Username, Password fields and Sign In button',
      (tester) async {
        await tester.pumpWidget(testWidget());
        expect(find.text('Server URL'), findsOneWidget);
        expect(find.text('Username'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.text('Sign In'), findsOneWidget);
      },
    );

    testWidgets(
      'token tab shows Access Token field and Sign In with Token button',
      (tester) async {
        await tester.pumpWidget(testWidget());
        await tester.tap(find.text('Access Token'));
        await tester.pumpAndSettle();
        expect(find.text('Sign In with Token'), findsOneWidget);
        final tokenFormFields = find.byType(TextFormField);
        expect(tokenFormFields, findsWidgets);
        final accessTokenLabel = find.text('Access Token');
        expect(accessTokenLabel, findsWidgets);
      },
    );

    testWidgets('password field is obscured by default', (tester) async {
      await tester.pumpWidget(testWidget());
      final fields = find.byType(TextField);
      final passwordField = tester.widget<TextField>(fields.at(2));
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('token field is obscured by default', (tester) async {
      await tester.pumpWidget(testWidget());
      await tester.tap(find.text('Access Token'));
      await tester.pumpAndSettle();
      final fields = find.byType(TextField);
      final tokenField = tester.widget<TextField>(fields.at(1));
      expect(tokenField.obscureText, isTrue);
    });

    testWidgets(
      'validation errors show when submitting empty basic auth form',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        await tester.pumpWidget(testWidget());
        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();
        expect(find.text('Please enter a server URL'), findsOneWidget);
        expect(find.text('Please enter your username'), findsOneWidget);
        expect(find.text('Please enter your password'), findsOneWidget);
      },
    );

    testWidgets('validation errors show when submitting empty token form', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(testWidget());
      await tester.tap(find.text('Access Token'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign In with Token'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter a server URL'), findsOneWidget);
      expect(find.text('Please enter an access token'), findsOneWidget);
    });

    testWidgets('server URL validation rejects invalid URLs', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(testWidget());
      await tester.enterText(find.byType(TextFormField).at(0), 'not-a-url');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter a valid URL'), findsOneWidget);
    });

    testWidgets('password visibility toggle works', (tester) async {
      await tester.pumpWidget(testWidget());
      final fields = find.byType(TextField);
      expect(tester.widget<TextField>(fields.at(2)).obscureText, isTrue);
      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pump();
      expect(tester.widget<TextField>(fields.at(2)).obscureText, isFalse);
    });
  });
}
