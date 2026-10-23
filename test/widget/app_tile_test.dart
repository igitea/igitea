import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:igitea/presentation/widgets/forui/app_tile.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  testWidgets('renders title, subtitle and chevron, fires onPress', (
    tester,
  ) async {
    var pressed = false;
    await tester.pumpWidget(
      buildTestableWidget(
        Scaffold(
          body: AppTile(
            leading: const Icon(FIcons.star),
            title: '议题',
            subtitle: '提及我的',
            onPress: () => pressed = true,
          ),
        ),
      ),
    );

    expect(find.text('议题'), findsOneWidget);
    expect(find.text('提及我的'), findsOneWidget);
    expect(find.byIcon(FIcons.star), findsOneWidget);
    expect(find.byIcon(FIcons.chevronRight), findsOneWidget);

    await tester.tap(find.text('议题'));
    await tester.pumpAndSettle();
    expect(pressed, isTrue);
  });

  testWidgets('hides the chevron when a trailing widget is provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestableWidget(
        Scaffold(
          body: AppTile(
            title: '议题',
            trailing: const Text('3'),
            onPress: () {},
          ),
        ),
      ),
    );

    expect(find.text('3'), findsOneWidget);
    expect(find.byIcon(FIcons.chevronRight), findsNothing);
  });
}
