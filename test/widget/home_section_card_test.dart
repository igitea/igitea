import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/presentation/widgets/home/home_section_card.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  testWidgets('renders title and children with dividers', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        Material(
          child: HomeSectionCard(
            title: '收藏',
            children: [
              const SizedBox(height: 40, child: Text('row1')),
              const SizedBox(height: 40, child: Text('row2')),
            ],
          ),
        ),
      ),
    );

    expect(find.text('收藏'), findsOneWidget);
    expect(find.text('row1'), findsOneWidget);
    expect(find.text('row2'), findsOneWidget);
    expect(find.byType(Divider), findsOneWidget);
  });

  testWidgets('hides header when showHeader is false', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        Material(
          child: HomeSectionCard(
            title: '隐藏标题',
            showHeader: false,
            children: [const SizedBox(height: 40, child: Text('row'))],
          ),
        ),
      ),
    );

    expect(find.text('隐藏标题'), findsNothing);
    expect(find.text('row'), findsOneWidget);
  });

  testWidgets('renders nothing when children are empty', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        const Material(
          child: HomeSectionCard(title: '空', children: []),
        ),
      ),
    );

    expect(find.byType(HomeSectionCard), findsOneWidget);
    expect(find.byType(Card), findsNothing);
  });
}
