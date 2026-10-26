import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/core/platform/desktop_layout.dart';
import 'package:igitea/core/storage/auth_method_storage.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/entities/auth_state.dart';
import 'package:igitea/presentation/pages/home_page.dart';
import 'package:igitea/presentation/widgets/forui/app_chrome.dart';
import 'package:igitea/widget_test_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Injection.initialize();
  });

  Future<void> pumpAt(
    WidgetTester tester,
    Size size,
    TargetPlatform platform,
    Widget child,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    debugDefaultTargetPlatformOverride = platform;
    await tester.pumpWidget(
      buildTestableWidget(child, touch: DesktopLayout.isTouch(platform)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a landscape tablet gets the multi-pane workspace', (
    tester,
  ) async {
    late bool desktop;
    late bool repository;
    await pumpAt(
      tester,
      const Size(1180, 820),
      TargetPlatform.iOS,
      Builder(
        builder: (context) {
          desktop = DesktopLayout.isDesktop(context);
          repository = DesktopLayout.isRepositoryDesktop(context);
          return const SizedBox();
        },
      ),
    );
    expect(desktop, isTrue);
    expect(repository, isTrue);
    expect(DesktopLayout.isTouch(TargetPlatform.iOS), isTrue);
    expect(DesktopLayout.isTouch(TargetPlatform.macOS), isFalse);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('a portrait tablet uses a captioned rail without key hints', (
    tester,
  ) async {
    Injection.authNotifier.state = AuthAuthenticated(
      baseUrl: 'https://gitea.example.com',
      method: AuthMethod.token,
      token: 'test-token',
      user: User(id: 1, login: 'testuser'),
    );
    await Injection.themeNotifier.setSidebarCollapsed(false);

    await pumpAt(
      tester,
      const Size(820, 1180),
      TargetPlatform.iOS,
      const HomePage(),
    );

    final sidebarItems = tester.widgetList<SidebarNavItem>(
      find.byType(SidebarNavItem),
    );
    expect(sidebarItems, isNotEmpty);
    expect(sidebarItems.every((item) => item.compact), isTrue);
    expect(find.byType(KbdHint), findsNothing);
    expect(find.text('Inbox'), findsWidgets);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('a desktop window keeps the expanded sidebar and key hints', (
    tester,
  ) async {
    Injection.authNotifier.state = AuthAuthenticated(
      baseUrl: 'https://gitea.example.com',
      method: AuthMethod.token,
      token: 'test-token',
      user: User(id: 1, login: 'testuser'),
    );
    await Injection.themeNotifier.setSidebarCollapsed(false);

    await pumpAt(
      tester,
      const Size(1400, 900),
      TargetPlatform.macOS,
      const HomePage(),
    );

    final sidebarItems = tester.widgetList<SidebarNavItem>(
      find.byType(SidebarNavItem),
    );
    expect(sidebarItems.every((item) => !item.compact), isTrue);
    expect(find.byType(KbdHint), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });
}
