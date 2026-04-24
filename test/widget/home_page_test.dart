import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/core/storage/auth_method_storage.dart';
import 'package:igitea/domain/entities/auth_state.dart';
import 'package:igitea/presentation/pages/home_page.dart';
import 'package:igitea/presentation/pages/search_page.dart';

void main() {
  setUp(() {
    Injection.initialize();
    Injection.authNotifier.state = const AuthInitial();
  });

  Widget testWidget() {
    return const MaterialApp(home: HomePage());
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

      expect(find.text('Search'), findsAtLeast(1));
      expect(find.text('Dashboard'), findsAtLeast(1));
      expect(find.text('Repositories'), findsAtLeast(1));
      expect(find.text('Issues'), findsAtLeast(1));
      expect(find.text('Notifications'), findsAtLeast(1));
      expect(find.text('Profile'), findsAtLeast(1));
    });

    testWidgets('shows logged in user name in app bar', (tester) async {
      Injection.authNotifier.state = testAuthState;

      await tester.pumpWidget(testWidget());
      await tester.pumpAndSettle();

      expect(find.text('testuser'), findsOneWidget);
    });

    testWidgets('shows sign out button', (tester) async {
      Injection.authNotifier.state = testAuthState;

      await tester.pumpWidget(testWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('shows search page as default tab', (tester) async {
      Injection.authNotifier.state = testAuthState;

      await tester.pumpWidget(testWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SearchPage), findsOneWidget);
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