import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/core/storage/auth_method_storage.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/entities/auth_state.dart';
import 'package:igitea/presentation/pages/repo_detail_page.dart';
import 'package:igitea/presentation/state/repo_notifier.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
    Injection.authNotifier.state = AuthAuthenticated(
      baseUrl: 'https://gitea.example.com',
      method: AuthMethod.token,
      token: 'test-token',
      user: User(id: 1, login: 'testuser'),
    );
  });

  testWidgets('renders loading initially', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(const RepoDetailPage(owner: 'testowner', repo: 'testrepo')),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders tab bar with 5 tabs', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(const RepoDetailPage(owner: 'testowner', repo: 'testrepo')),
    );
    await tester.pump();

    Injection.repoNotifier.state = RepoLoaded(
      Repository(id: 1, name: 'testrepo', owner: User(id: 1, login: 'testowner')),
    );
    await tester.pump();

    expect(find.text('Code'), findsOneWidget);
    expect(find.text('Issues'), findsOneWidget);
    expect(find.text('Pull Requests'), findsOneWidget);
    expect(find.text('Releases'), findsOneWidget);
    expect(find.text('Branches'), findsOneWidget);
  });
}
