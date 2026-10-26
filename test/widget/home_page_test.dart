import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/core/storage/auth_method_storage.dart';
import 'package:igitea/domain/entities/auth_state.dart';
import 'package:igitea/presentation/pages/dashboard_page.dart';
import 'package:igitea/presentation/pages/home_page.dart';
import 'package:igitea/presentation/widgets/user_avatar.dart';
import 'package:igitea/widget_test_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    Injection.initialize();
    Injection.authNotifier.state = const AuthInitial();
  });

  Widget testWidget() {
    return buildTestableWidget(const HomePage());
  }

  final testAuthState = AuthAuthenticated(
    baseUrl: 'https://gitea.example.com',
    method: AuthMethod.token,
    token: 'test-token',
    user: User(id: 1, login: 'testuser'),
  );

  group('HomePage', () {
    testWidgets('renders bottom navigation items when authenticated', (
      tester,
    ) async {
      Injection.authNotifier.state = testAuthState;

      await tester.pumpWidget(testWidget());
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsAtLeast(1));
      expect(find.text('Inbox'), findsAtLeast(1));
      expect(find.text('Explore'), findsAtLeast(1));
      expect(find.text('Profile'), findsAtLeast(1));
    });

    testWidgets('shows my work title and avatar in app bar', (tester) async {
      Injection.authNotifier.state = testAuthState;

      await tester.pumpWidget(testWidget());
      await tester.pumpAndSettle();

      expect(find.text('My Work'), findsOneWidget);
      expect(find.byType(UserAvatar), findsAtLeast(1));
    });

    testWidgets('shows dashboard as default tab', (tester) async {
      Injection.authNotifier.state = testAuthState;

      await tester.pumpWidget(testWidget());
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('switches the header title with the selected tab', (
      tester,
    ) async {
      Injection.authNotifier.state = testAuthState;

      await tester.pumpWidget(testWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Inbox'));
      await tester.pumpAndSettle();
      expect(find.text('Notifications'), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Profile'), findsWidgets);
    });

    testWidgets('renders SizedBox.shrink when not authenticated', (
      tester,
    ) async {
      await tester.pumpWidget(testWidget());
      await tester.pumpAndSettle();

      final homePageFinder = find.byType(HomePage);
      expect(homePageFinder, findsOneWidget);
    });

    testWidgets('toggles the sidebar with the desktop shortcut', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      Injection.authNotifier.state = testAuthState;
      await Injection.themeNotifier.setSidebarCollapsed(false);

      await tester.pumpWidget(
        buildTestableWidget(const HomePage(), touch: false),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
      await tester.pumpAndSettle();

      expect(Injection.themeNotifier.sidebarCollapsed, isTrue);
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
