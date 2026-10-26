import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/core/storage/auth_method_storage.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/entities/auth_state.dart';
import 'package:igitea/presentation/pages/repo_detail_page.dart';
import 'package:igitea/presentation/state/repo_notifier.dart';
import 'package:igitea/presentation/widgets/desktop/app_three_pane.dart';
import 'package:igitea/widget_test_helpers.dart';

final _testRepo = Repository(
  id: 1,
  name: 'igitea',
  full_name: 'charley/igitea',
  description: 'A calm, cross-platform Gitea client.',
  owner: User(id: 1, login: 'charley'),
  default_branch: 'main',
  private: false,
  stars_count: 1284,
  forks_count: 96,
  watchers_count: 42,
  open_issues_count: 17,
  topics: const ['flutter', 'desktop'],
  clone_url: 'https://gitea.example.com/charley/igitea.git',
  ssh_url: 'git@gitea.example.com:charley/igitea.git',
  html_url: 'https://gitea.example.com/charley/igitea',
  website: 'https://igitea.dev',
  created_at: DateTime.utc(2024, 1, 12),
  updated_at: DateTime.utc(2026, 10, 20),
);

void main() {
  setUp(() {
    Injection.initialize();
    Injection.authNotifier.state = AuthAuthenticated(
      baseUrl: 'https://gitea.example.com',
      method: AuthMethod.token,
      token: 'test-token',
      user: User(id: 1, login: 'charley', full_name: 'Charley Peng'),
    );
  });

  testWidgets('renders the three-pane repository workspace on desktop', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

    await tester.pumpWidget(
      buildTestableWidget(
        const RepoDetailPage(owner: 'charley', repo: 'igitea'),
        touch: false,
      ),
    );
    await tester.pump();

    Injection.repoNotifier.state = RepoLoaded(_testRepo);
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AppThreePane), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('SOURCE CONTROL'), findsOneWidget);
    expect(find.text('COLLABORATION'), findsOneWidget);
    expect(find.text('Clone URL'), findsOneWidget);
    expect(find.text('New Issue'), findsOneWidget);
    expect(find.text('Repository Sections'), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('keeps the mobile section list on narrow windows', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestableWidget(
        const RepoDetailPage(owner: 'charley', repo: 'igitea'),
      ),
    );
    await tester.pump();

    Injection.repoNotifier.state = RepoLoaded(_testRepo);
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AppThreePane), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Repository Sections'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Repository Sections'), findsOneWidget);
  });
}
