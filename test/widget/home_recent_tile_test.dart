import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/presentation/widgets/home/home_recent_tile.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  testWidgets('renders repo, title, time and status', (tester) async {
    final thread = NotificationThread(
      repository: Repository(full_name: 'igitea/igitea'),
      subject: NotificationSubject(
        title: '仪表盘重构',
        url: 'https://gitea.example.com/api/v1/repos/igitea/igitea/issues/3',
      ),
      unread: true,
    );
    await tester.pumpWidget(
      buildTestableWidget(
        Material(
          child: HomeRecentTile(
            thread: thread,
            timeText: '9天',
            statusText: '已分配给你',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.textContaining('igitea/igitea'), findsOneWidget);
    expect(find.textContaining('#3'), findsOneWidget);
    expect(find.text('仪表盘重构'), findsOneWidget);
    expect(find.text('9天'), findsOneWidget);
    expect(find.text('已分配给你'), findsOneWidget);
  });

  testWidgets('omits number when subject url has none', (tester) async {
    final thread = NotificationThread(
      repository: Repository(full_name: 'igitea/igitea'),
      subject: NotificationSubject(title: '无编号'),
    );
    await tester.pumpWidget(
      buildTestableWidget(
        Material(
          child: HomeRecentTile(
            thread: thread,
            timeText: '',
            statusText: '',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.textContaining('igitea/igitea'), findsOneWidget);
    expect(find.textContaining('#'), findsNothing);
    expect(find.text('无编号'), findsOneWidget);
  });
}
