import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:igitea/presentation/widgets/desktop/app_hover_region.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  group('AppHoverRegion', () {
    testWidgets('debounces hover enter and exit', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(() {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic;
      });

      await tester.pumpWidget(
        buildTestableWidget(
          Center(
            child: AppHoverRegion(
              onTap: () {},
              hoverColor: Colors.red,
              borderColor: Colors.black,
              enterDelay: const Duration(milliseconds: 40),
              exitDelay: const Duration(milliseconds: 60),
              contentBuilder: (context, hovered, focused) =>
                  Text(hovered ? 'hovered' : 'idle'),
            ),
          ),
          touch: false,
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: const Offset(2, 2));
      addTearDown(gesture.removePointer);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.byType(AppHoverRegion)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      expect(
        find.text('idle'),
        findsOneWidget,
        reason: 'hover is still inside the intent delay',
      );

      await tester.pump(const Duration(milliseconds: 40));
      expect(find.text('hovered'), findsOneWidget);

      await gesture.moveTo(const Offset(700, 500));
      await tester.pump(const Duration(milliseconds: 30));
      expect(
        find.text('hovered'),
        findsOneWidget,
        reason: 'leaving does not clear the highlight immediately',
      );

      await tester.pump(const Duration(milliseconds: 70));
      expect(find.text('idle'), findsOneWidget);
    });

    testWidgets('hover fade never passes through a dark intermediate colour', (
      tester,
    ) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(() {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic;
      });

      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        buildTestableWidget(
          Center(
            child: RepaintBoundary(
              key: boundaryKey,
              child: ColoredBox(
                color: Colors.white,
                child: AppHoverRegion(
                  onTap: () {},
                  hoverColor: const Color(0xFFEFF3F1),
                  enterDelay: Duration.zero,
                  animationDuration: const Duration(milliseconds: 110),
                  child: const SizedBox(width: 120, height: 80),
                ),
              ),
            ),
          ),
          touch: false,
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: const Offset(2, 2));
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(AppHoverRegion)));
      await tester.pump();

      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;

      var sawWash = false;
      for (var frame = 0; frame < 12; frame++) {
        await tester.pump(const Duration(milliseconds: 10));
        final rgb = await tester.runAsync(() async {
          final image = await boundary.toImage();
          final width = image.width;
          final data = await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );
          image.dispose();
          final bytes = data!.buffer.asUint8List();
          final offset = (10 * width + 10) * 4;
          return [bytes[offset], bytes[offset + 1], bytes[offset + 2]];
        });
        final r = rgb![0];
        final g = rgb[1];
        final b = rgb[2];
        final luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b;
        sawWash = sawWash || luminance < 250;
        expect(
          luminance,
          greaterThan(225),
          reason:
              'frame $frame faded through dark grey '
              '(rgb $r,$g,$b). Animate alpha, not transparent black.',
        );
      }
      expect(
        sawWash,
        isTrue,
        reason: 'the hover wash should be visible in at least one frame',
      );
    });

    testWidgets('opens a context menu on secondary click', (tester) async {
      var selected = false;
      await tester.pumpWidget(
        buildTestableWidget(
          Center(
            child: AppHoverRegion(
              onTap: () {},
              contextMenuItems: [
                AppMenuItem(
                  label: 'Copy link',
                  icon: FIcons.copy,
                  onSelected: () => selected = true,
                ),
              ],
              child: const SizedBox(width: 180, height: 60, child: Text('row')),
            ),
          ),
          touch: false,
        ),
      );

      await tester.tap(find.text('row'), buttons: kSecondaryMouseButton);
      await tester.pumpAndSettle();
      expect(find.text('Copy link'), findsOneWidget);

      await tester.tap(find.text('Copy link'));
      await tester.pumpAndSettle();
      expect(selected, isTrue);
    });

    testWidgets('single and double click both reach the row', (tester) async {
      var presses = 0;
      var doublePresses = 0;
      await tester.pumpWidget(
        buildTestableWidget(
          Center(
            child: AppHoverRegion(
              onTap: () => presses++,
              onDoubleTap: () => doublePresses++,
              child: const SizedBox(width: 180, height: 60, child: Text('row')),
            ),
          ),
          touch: false,
        ),
      );

      await tester.tap(find.text('row'));
      await tester.pump(const Duration(milliseconds: 60));
      await tester.tap(find.text('row'));
      await tester.pumpAndSettle();

      expect(doublePresses, 1);
      expect(presses, greaterThanOrEqualTo(2));
    });

    testWidgets('keyboard activation invokes onTap', (tester) async {
      var presses = 0;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildTestableWidget(
          Center(
            child: AppHoverRegion(
              onTap: () => presses++,
              focusNode: focusNode,
              child: const SizedBox(width: 180, height: 60, child: Text('row')),
            ),
          ),
          touch: false,
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(presses, 1);
    });
  });
}
