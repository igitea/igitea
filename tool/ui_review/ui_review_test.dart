// ignore_for_file: invalid_use_of_visible_for_testing_member
// Renders key screens with a fake backend at phone, tablet and desktop sizes.
//
//   flutter test tool/ui_review --update-goldens
//
// PNGs are written to tool/ui_review/out/ (git-ignored).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:igitea/app.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/core/storage/auth_method_storage.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/entities/auth_state.dart';
import 'package:igitea/l10n/app_localizations.dart';
import 'package:igitea/presentation/models/issue_filter_state.dart';
import 'package:igitea/presentation/pages/home_page.dart';
import 'package:igitea/presentation/pages/issue_detail_page.dart';
import 'package:igitea/presentation/pages/issue_list_page.dart';
import 'package:igitea/presentation/pages/login_page.dart';
import 'package:igitea/presentation/pages/pr_detail_page.dart';
import 'package:igitea/presentation/pages/repo_detail_page.dart';
import 'package:igitea/presentation/pages/settings_page.dart';
import 'package:igitea/presentation/theme/app_theme.dart';
import 'package:igitea/presentation/widgets/desktop/app_scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fixtures.dart';

class Device {
  const Device(this.name, this.size, this.platform, {this.padding});
  final String name;
  final Size size;
  final TargetPlatform platform;
  final EdgeInsets? padding;
}

const devices = [
  Device(
    'phone',
    Size(393, 852),
    TargetPlatform.iOS,
    padding: EdgeInsets.only(top: 59, bottom: 34),
  ),
  Device(
    'tablet',
    Size(820, 1180),
    TargetPlatform.iOS,
    padding: EdgeInsets.only(top: 24, bottom: 20),
  ),
  Device(
    'tablet_land',
    Size(1180, 820),
    TargetPlatform.iOS,
    padding: EdgeInsets.only(top: 24, bottom: 20),
  ),
  Device('desktop', Size(1440, 900), TargetPlatform.macOS),
];

final only = Platform.environment['UI_REVIEW_ONLY'];
final onlyDevice = Platform.environment['UI_REVIEW_DEVICE'];
final dark = Platform.environment['UI_REVIEW_DARK'] == '1';

Future<void> _loadFonts() async {
  final config =
      jsonDecode(File('.dart_tool/package_config.json').readAsStringSync())
          as Map<String, dynamic>;
  String root(String name) {
    final pkg = (config['packages'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((p) => p['name'] == name);
    return Uri.parse(pkg['rootUri'] as String).toFilePath();
  }

  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      final bytes = File(f).readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }

  final forui = root('forui');
  final interFiles = [
    for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold'])
      '$forui/assets/fonts/inter/Inter-$w.ttf',
  ];
  await load('packages/forui/Inter', interFiles);
  await load('Inter', interFiles);
  await load('packages/forui_assets/ForuiLucideIcons', [
    '${root('forui_assets')}/assets/lucide.ttf',
  ]);
  final flutterRoot = Platform.environment['FLUTTER_ROOT']!;
  final material = '$flutterRoot/bin/cache/artifacts/material_fonts';
  await load('MaterialIcons', ['$material/MaterialIcons-Regular.otf']);
  await load('Roboto', [
    '$material/Roboto-Regular.ttf',
    '$material/Roboto-Medium.ttf',
    '$material/Roboto-Bold.ttf',
  ]);
  for (final mono in [
    '/System/Library/Fonts/SFNSMono.ttf',
    '/System/Library/Fonts/Menlo.ttc',
  ]) {
    if (File(mono).existsSync()) {
      await load('monospace', [mono]);
      await load('Menlo', [mono]);
      await load('SF Mono', [mono]);
      break;
    }
  }
}

Widget _app(Widget home, TargetPlatform platform) {
  final touch = AppTheme.touchFor(platform);
  final brightness = dark ? Brightness.dark : Brightness.light;
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    scrollBehavior: const AppScrollBehavior(),
    localizationsDelegates: [
      ...AppLocalizations.localizationsDelegates,
      FLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.material(brightness, touch: touch),
    builder: (context, child) => IGiteaApp.wrap(context, child, touch: touch),
    home: home,
  );
}

final scenarios = <String, Widget Function()>{
  'login': () => const LoginPage(),
  'home': () => const HomePage(),
  'inbox': () => const HomePage(),
  'explore': () => const HomePage(),
  'profile': () => const HomePage(),
  'repo': () => const RepoDetailPage(owner: 'charley', repo: 'igitea'),
  'issues': () =>
      const IssueListPage(initialFilter: IssueFilterState(type: 'issues')),
  'issue': () =>
      const IssueDetailPage(owner: 'charley', repo: 'igitea', index: 42),
  'pull': () => const PRDetailPage(owner: 'charley', repo: 'igitea', index: 44),
  'settings': () => const SettingsPage(),
};

const _tabIndex = {'inbox': 1, 'explore': 2, 'profile': 3};

void main() {
  setUpAll(() async {
    await _loadFonts();
  });

  tearDownAll(() {
    if (unmatched.isNotEmpty) {
      // ignore: avoid_print
      print('UNMATCHED:\n${unmatched.join('\n')}');
    }
  });

  for (final device in devices) {
    if (onlyDevice != null && !onlyDevice!.split(',').contains(device.name)) {
      continue;
    }
    for (final entry in scenarios.entries) {
      if (only != null && !only!.split(',').contains(entry.key)) continue;
      testWidgets('${entry.key} @ ${device.name}', (tester) async {
        SharedPreferences.setMockInitialValues({});
        debugDefaultTargetPlatformOverride = device.platform;
        tester.view.devicePixelRatio = 2;
        tester.view.physicalSize = device.size * 2;
        if (device.padding != null) {
          final p = device.padding!;
          tester.view.padding = FakeViewPadding(
            top: p.top * 2,
            bottom: p.bottom * 2,
          );
          tester.view.viewPadding = FakeViewPadding(
            top: p.top * 2,
            bottom: p.bottom * 2,
          );
        }
        addTearDown(tester.view.reset);

        Injection.httpClientOverride = fakeGiteaClient();
        Injection.initialize(baseUrl: 'https://git.example.com', token: 't');
        if (entry.key != 'login') {
          Injection.authNotifier.state = AuthAuthenticated(
            baseUrl: 'https://git.example.com',
            method: AuthMethod.token,
            token: 't',
            user: User.fromJson({
              'id': 1,
              'login': 'charley',
              'full_name': 'Charley Peng',
              'avatar_url': '',
              'is_admin': true,
            }),
          );
        }

        final key = GlobalKey();
        await tester.pumpWidget(
          RepaintBoundary(
            key: key,
            child: _app(entry.value(), device.platform),
          ),
        );
        for (var i = 0; i < 8; i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 30)),
          );
          await tester.pump(const Duration(milliseconds: 100));
        }
        final tab = _tabIndex[entry.key];
        if (tab != null) {
          final label = const ['Home', 'Inbox', 'Explore', 'Profile'][tab];
          await tester.tap(find.text(label).last);
          for (var i = 0; i < 8; i++) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 30)),
            );
            await tester.pump(const Duration(milliseconds: 100));
          }
        }
        await tester.pump(const Duration(seconds: 2));
        final suffix = dark ? '_dark' : '';
        await expectLater(
          find.byKey(key),
          matchesGoldenFile('out/${entry.key}_${device.name}$suffix.png'),
        );
        await tester.pumpWidget(const SizedBox.shrink());
        debugDefaultTargetPlatformOverride = null;
      });
    }
  }
}
