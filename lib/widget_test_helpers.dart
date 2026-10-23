import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'package:igitea/l10n/app_localizations.dart';
import 'package:igitea/presentation/theme/app_theme.dart';

Widget buildTestableWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: [
      ...AppLocalizations.localizationsDelegates,
      FLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.material(Brightness.light, touch: true),
    builder: (context, child) => FTheme(
      data: AppTheme.forui(Brightness.light, touch: true),
      platform: FPlatformVariant.iOS,
      child: FToaster(child: child ?? const SizedBox.shrink()),
    ),
    home: child,
  );
}
