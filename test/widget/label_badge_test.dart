import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/presentation/theme/app_palette.dart';
import 'package:igitea/presentation/widgets/avatar_fallback.dart';
import 'package:igitea/presentation/widgets/label_badge.dart';
import 'package:igitea/widget_test_helpers.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (la > lb ? la + 0.05 : lb + 0.05) / (la > lb ? lb + 0.05 : la + 0.05);
}

void main() {
  test('parseLabelColor accepts hex with or without a hash', () {
    expect(parseLabelColor('#d73a4a'), const Color(0xFFD73A4A));
    expect(parseLabelColor('0e8a7d'), const Color(0xFF0E8A7D));
    expect(parseLabelColor(''), isNull);
    expect(parseLabelColor('zzz'), isNull);
  });

  test('readableOn darkens pale label colors on light surfaces', () {
    const pale = Color(0xFFA2EEEF);
    final text = readableOn(pale, Colors.white);
    expect(_contrast(text, Colors.white), greaterThanOrEqualTo(4.5));
  });

  test('readableOn lightens dark label colors on dark surfaces', () {
    const deep = Color(0xFF1D2B6B);
    final background = AppPalette.dark.surface;
    final text = readableOn(deep, background);
    expect(_contrast(text, background), greaterThanOrEqualTo(4.5));
  });

  testWidgets('LabelRow collapses extra labels into a count', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        Center(
          child: LabelRow(
            maxShow: 2,
            labels: [
              Label(id: 1, name: 'bug', color: 'd73a4a'),
              Label(id: 2, name: 'ui', color: '0e8a7d'),
              Label(id: 3, name: 'perf', color: 'fbca04'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('bug'), findsOneWidget);
    expect(find.text('ui'), findsOneWidget);
    expect(find.text('perf'), findsNothing);
    expect(find.text('+1'), findsOneWidget);
  });

  testWidgets('AvatarFallback shows a stable initial', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        const Center(child: AvatarFallback(name: 'mira', size: 32)),
      ),
    );
    expect(find.text('M'), findsOneWidget);
  });
}
