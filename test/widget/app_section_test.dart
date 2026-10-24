import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/presentation/widgets/app_surface.dart';
import 'package:igitea/presentation/widgets/forui/app_section.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  testWidgets('renders title and children with dividers', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        Scaffold(
          body: AppSection(
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
    expect(find.byType(AppSurface), findsOneWidget);
  });

  testWidgets('hides header when showHeader is false', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        Scaffold(
          body: AppSection(
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

  testWidgets('renders trailing widget in the header', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        Scaffold(
          body: AppSection(
            title: '最近',
            trailing: const Text('查看全部'),
            children: [const SizedBox(height: 40, child: Text('row'))],
          ),
        ),
      ),
    );

    expect(find.text('查看全部'), findsOneWidget);
  });

  testWidgets('renders nothing when children are empty', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        const Scaffold(
          body: AppSection(title: '空', children: []),
        ),
      ),
    );

    expect(find.byType(AppSection), findsOneWidget);
    expect(find.byType(AppSurface), findsNothing);
  });
}
