import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/core/storage/auth_method_storage.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/entities/auth_state.dart';
import 'package:igitea/presentation/pages/issue_detail_page.dart';
import 'package:igitea/presentation/state/issue_notifier.dart';
import 'package:igitea/presentation/widgets/comment_composer.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  Future<List<String>> pumpComposer(
    WidgetTester tester,
    TextEditingController controller,
  ) async {
    final sent = <String>[];
    await tester.pumpWidget(
      buildTestableWidget(
        Scaffold(
          body: Column(
            children: [
              const Expanded(child: SizedBox()),
              CommentComposer(
                controller: controller,
                onSend: (body) async => sent.add(body),
              ),
            ],
          ),
        ),
        touch: false,
      ),
    );
    return sent;
  }

  testWidgets('sends the trimmed comment and clears the field', (tester) async {
    final controller = TextEditingController();
    final sent = await pumpComposer(tester, controller);

    await tester.tap(find.bySemanticsLabel('Comment'));
    await tester.pump();
    expect(sent, isEmpty);

    await tester.enterText(find.byType(EditableText), '  Looks good  ');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Comment'));
    await tester.pumpAndSettle();

    expect(sent, ['Looks good']);
    expect(controller.text, isEmpty);
  });

  testWidgets('Ctrl+Enter sends from the field', (tester) async {
    final controller = TextEditingController();
    final sent = await pumpComposer(tester, controller);

    await tester.enterText(find.byType(EditableText), 'Ship it');
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();

    expect(sent, ['Ship it']);
  });

  testWidgets('the issue page keeps the composer outside the thread', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    Injection.initialize();
    Injection.authNotifier.state = AuthAuthenticated(
      baseUrl: 'https://gitea.example.com',
      method: AuthMethod.token,
      token: 'test-token',
      user: User(id: 1, login: 'charley'),
    );

    await tester.pumpWidget(
      buildTestableWidget(
        const IssueDetailPage(owner: 'charley', repo: 'igitea', index: 7),
        touch: false,
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    Injection.issueNotifier.state = IssueDetailLoaded(
      Issue(
        id: 7,
        number: 7,
        title: 'Keep the composer in view',
        state: const StateType(value: 'open'),
        user: User(id: 2, login: 'mira'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    final composer = find.byType(CommentComposer);
    expect(composer, findsOneWidget);
    expect(
      find.ancestor(of: composer, matching: find.byType(Scrollable)),
      findsNothing,
    );
    debugDefaultTargetPlatformOverride = null;
  });
}
