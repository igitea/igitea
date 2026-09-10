import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/l10n/app_localizations.dart';
import 'package:igitea/presentation/widgets/activity_tile.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  Activity activityWith(String? opType) =>
      Activity(op_type: opType, ref_name: 'refs/heads/main');

  Future<AppLocalizations> l10nOf(WidgetTester tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(buildTestableWidget(Builder(
      builder: (context) {
        l10n = AppLocalizations.of(context)!;
        return const SizedBox();
      },
    )));
    return l10n;
  }

  testWidgets('describeActivity maps known op types', (tester) async {
    final l10n = await l10nOf(tester);
    expect(describeActivity(activityWith('create_repo'), l10n),
        'created a repository');
    expect(describeActivity(activityWith('push'), l10n), 'pushed commits');
    expect(describeActivity(activityWith('create_issue'), l10n),
        'opened an issue');
    expect(describeActivity(activityWith('create_pull_request'), l10n),
        'opened a pull request');
    expect(describeActivity(activityWith('merge_pull_request'), l10n),
        'merged a pull request');
    expect(describeActivity(activityWith('comment_issue'), l10n),
        'commented on an issue');
    expect(describeActivity(activityWith('comment_pull'), l10n),
        'commented on a pull request');
    expect(describeActivity(activityWith('publish_release'), l10n),
        'published a release');
    expect(describeActivity(activityWith('star_repo'), l10n), 'starred');
    expect(describeActivity(activityWith('fork_repo'), l10n), 'forked');
    expect(describeActivity(activityWith('approve_pull_request'), l10n),
        'approved a pull request');
    expect(describeActivity(activityWith('reject_pull_request'), l10n),
        'requested changes on a pull request');
  });

  testWidgets('describeActivity falls back for unknown op types',
      (tester) async {
    final l10n = await l10nOf(tester);
    expect(describeActivity(activityWith('some_new_op'), l10n), 'some new op');
    expect(describeActivity(activityWith(null), l10n), '');
  });

  test('shortRefName strips refs prefixes', () {
    expect(shortRefName('refs/heads/main'), 'main');
    expect(shortRefName('refs/tags/v1.0'), 'v1.0');
    expect(shortRefName('feature/x'), 'feature/x');
    expect(shortRefName(''), '');
    expect(shortRefName(null), '');
  });

  testWidgets('activityIcon returns distinct icons per category',
      (tester) async {
    expect(activityIcon(activityWith('push')), Icons.commit);
    expect(activityIcon(activityWith('create_issue')), Icons.bug_report_outlined);
    expect(activityIcon(activityWith('create_pull_request')), Icons.merge_type);
    expect(activityIcon(activityWith('merge_pull_request')), Icons.call_merge);
    expect(activityIcon(activityWith('star_repo')), Icons.star_outline);
    expect(activityIcon(activityWith('unknown')), Icons.bolt_outlined);
  });
}
