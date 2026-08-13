import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/core/storage/auth_method_storage.dart';
import 'package:igitea/domain/entities/auth_state.dart';
import 'package:igitea/presentation/pages/dashboard_page.dart';
import 'package:igitea/presentation/pages/home_page.dart';
import 'package:igitea/widget_test_helpers.dart';

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
      expect(find.byType(CircleAvatar), findsAtLeast(1));
    });

    testWidgets('shows dashboard as default tab', (tester) async {
      Injection.authNotifier.state = testAuthState;

      await tester.pumpWidget(testWidget());
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('renders SizedBox.shrink when not authenticated', (
      tester,
    ) async {
      await tester.pumpWidget(testWidget());
      await tester.pumpAndSettle();

      final homePageFinder = find.byType(HomePage);
      expect(homePageFinder, findsOneWidget);
    });
  });
}
