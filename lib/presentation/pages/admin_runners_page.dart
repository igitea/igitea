import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_tile.dart';
import '../state/admin_notifier.dart';

class AdminRunnersPage extends StatefulWidget {
  const AdminRunnersPage({super.key});

  @override
  State<AdminRunnersPage> createState() => _AdminRunnersPageState();
}

class _AdminRunnersPageState extends State<AdminRunnersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.adminNotifier.loadRunners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPage(
      title: l10n.adminRunnersTitle,
      child: ListenableBuilder(
        listenable: Injection.adminNotifier,
        builder: (context, _) {
          final state = Injection.adminNotifier.runnersState;
          return switch (state) {
            AdminRunnersLoading() => const AppLoading(),
            AdminRunnersError(:final message) => AppError(
              message: message,
              onRetry: () => Injection.adminNotifier.loadRunners(),
            ),
            AdminRunnersLoaded(:final runners) => runners.isEmpty
              ? AppEmpty(icon: FIcons.activity, title: l10n.adminNoRunners)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  children: [
                    AppSection(
                      title: '',
                      showHeader: false,
                      children: [
                        for (final runner in runners)
                          AppTile(
                            leading: const Icon(FIcons.activity),
                            title: runner.name ?? l10n.unknown,
                            subtitle: [
                              if (runner.status != null)
                                'Status: ${runner.status}',
                              if (runner.busy != null)
                                'Busy: ${runner.busy! ? 'Yes' : 'No'}',
                            ].join(' · '),
                            showChevron: false,
                            onPress: null,
                          ),
                      ],
                    ),
                  ],
                ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
