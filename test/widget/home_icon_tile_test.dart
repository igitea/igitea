import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/presentation/widgets/home/home_icon_tile.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  testWidgets('renders title and chevron, fires onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      buildTestableWidget(
        Material(
          child: HomeIconTile(
            iconBg: const Color(0xFF2EA043),
            icon: Icons.star_outline,
            title: '议题',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('议题'), findsOneWidget);
    expect(find.byIcon(Icons.star_outline), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    await tester.tap(find.text('议题'));
    expect(tapped, isTrue);
  });

  testWidgets('renders subtitle when provided', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        Material(
          child: HomeIconTile(
            iconBg: const Color(0xFF0969DA),
            icon: Icons.alternate_email,
            title: '议题',
            subtitle: '已提及',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('已提及'), findsOneWidget);
  });
}
