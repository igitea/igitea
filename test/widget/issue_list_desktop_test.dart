import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/core/storage/auth_method_storage.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/entities/auth_state.dart';
import 'package:igitea/presentation/pages/issue_detail_page.dart';
import 'package:igitea/presentation/pages/issue_list_page.dart';
import 'package:igitea/presentation/state/issue_notifier.dart';
import 'package:igitea/widget_test_helpers.dart';

final _issue = Issue(
  id: 517,
  number: 517,
  title: 'Desktop: keep the repository navigation rail visible',
  state: const StateType(value: 'open'),
  user: User(id: 1, login: 'charley'),
  assignees: [User(id: 2, login: 'mei')],
  labels: [Label(id: 1, name: 'desktop', color: '0F766E')],
  milestone: Milestone(id: 3, title: 'Desktop workspace 1.0'),
  comments: 2,
  created_at: DateTime.utc(2026, 10, 10),
  updated_at: DateTime.utc(2026, 10, 18),
  repository: RepositoryMeta(
    id: 1,
    name: 'igitea',
    owner: 'charley',
    full_name: 'charley/igitea',
  ),
  html_url: 'https://gitea.example.com/charley/igitea/issues/517',
  body: 'The desktop workspace still falls back to the mobile list.',
);

void main() {
  setUp(() {
    Injection.initialize();
    Injection.issueNotifier.state = const IssueInitial();
    Injection.issueNotifier.issuesListState = const IssuesListInitial();
    Injection.authNotifier.state = AuthAuthenticated(
      baseUrl: 'https://gitea.example.com',
      method: AuthMethod.token,
      token: 'test-token',
      user: User(id: 1, login: 'charley', full_name: 'Charley Peng'),
    );
  });

  testWidgets('renders the list-detail workspace with a metadata rail', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

    await tester.pumpWidget(
      buildTestableWidget(const IssueListPage(), touch: false),
    );
    await tester.pump();
    // Let the page's initial network search fail so the injected list wins.
    await tester.pump(const Duration(milliseconds: 100));

    Injection.issueNotifier.issuesListState = IssuesListLoaded([
      _issue,
    ], hasMore: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Let the inline detail pane's initial load fail, then inject its data.
    await tester.pump(const Duration(milliseconds: 100));
    Injection.issueNotifier.state = IssueDetailLoaded(_issue);
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(IssueDetailPage), findsOneWidget);
    expect(find.byType(IssueDetailMetaRail), findsOneWidget);
    expect(find.text('DETAILS'), findsOneWidget);
    expect(find.text('STATUS'), findsOneWidget);
    expect(find.text('AUTHOR'), findsOneWidget);
    expect(find.text(_issue.title!), findsNWidgets(2));
    expect(find.text('Select an issue to preview it here'), findsNothing);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('shows the selection placeholder before an issue is loaded', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

    await tester.pumpWidget(
      buildTestableWidget(const IssueListPage(), touch: false),
    );
    await tester.pump();

    expect(find.text('No issue selected'), findsOneWidget);

    debugDefaultTargetPlatformOverride = null;
  });
}
