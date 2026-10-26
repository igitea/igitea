import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'package:igitea/l10n/app_localizations.dart';
import 'package:igitea/presentation/theme/app_theme.dart';

Widget buildTestableWidget(Widget child, {bool touch = true}) {
  return MaterialApp(
    localizationsDelegates: [
      ...AppLocalizations.localizationsDelegates,
      FLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.material(Brightness.light, touch: touch),
    builder: (context, child) => FTheme(
      data: AppTheme.forui(Brightness.light, touch: touch),
      platform: touch ? FPlatformVariant.iOS : FPlatformVariant.macOS,
      child: FToaster(child: child ?? const SizedBox.shrink()),
    ),
    home: child,
  );
}
