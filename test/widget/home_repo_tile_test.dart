import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/presentation/widgets/home/home_repo_tile.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  testWidgets('renders owner/name and fires onTap', (tester) async {
    var tapped = false;
    final repo = Repository(
      full_name: 'charleypeng/igitea',
      name: 'igitea',
      owner: User(id: 1, login: 'charleypeng'),
    );
    await tester.pumpWidget(
      buildTestableWidget(
        Material(
          child: HomeRepoTile(repo: repo, onTap: () => tapped = true),
        ),
      ),
    );

    expect(find.textContaining('charleypeng'), findsOneWidget);
    expect(find.textContaining('igitea'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    await tester.tap(find.textContaining('igitea'));
    expect(tapped, isTrue);
  });

  testWidgets('falls back to public icon when owner is null', (tester) async {
    final repo = Repository(full_name: 'org/repo', name: 'repo');
    await tester.pumpWidget(
      buildTestableWidget(
        Material(
          child: HomeRepoTile(repo: repo, onTap: () {}),
        ),
      ),
    );

    expect(find.byIcon(Icons.public), findsOneWidget);
    expect(find.textContaining('org'), findsOneWidget);
  });
}
