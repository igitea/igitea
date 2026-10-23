import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_tile.dart';
import '../state/admin_notifier.dart';

class AdminCronPage extends StatefulWidget {
  const AdminCronPage({super.key});

  @override
  State<AdminCronPage> createState() => _AdminCronPageState();
}

class _AdminCronPageState extends State<AdminCronPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.adminNotifier.loadCronTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPage(
      title: l10n.adminCronTitle,
      child: ListenableBuilder(
        listenable: Injection.adminNotifier,
        builder: (context, _) {
          final state = Injection.adminNotifier.cronState;
          return switch (state) {
            AdminCronLoading() => const AppLoading(),
            AdminCronError(:final message) => AppError(
              message: message,
              onRetry: () => Injection.adminNotifier.loadCronTasks(),
            ),
            AdminCronLoaded(:final tasks) => tasks.isEmpty
              ? AppEmpty(icon: FIcons.calendarClock, title: l10n.adminNoCron)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  children: [
                    AppSection(
                      title: '',
                      showHeader: false,
                      children: [
                        for (final task in tasks)
                          AppTile(
                            leading: const Icon(FIcons.calendarClock),
                            title: task.name ?? l10n.unknown,
                            subtitle: [
                              if (task.schedule != null)
                                '${l10n.schedule}: ${task.schedule}',
                              if (task.next != null)
                                '${l10n.next}: ${_formatDate(task.next!)}',
                              if (task.exec_times != null)
                                '${l10n.executions}: ${task.exec_times}',
                            ].join(' · '),
                            showChevron: false,
                            trailing: FTappable(
                              onPress: () => _runTask(context, task.name),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(FIcons.play, size: 16),
                              ),
                            ),
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

  Future<void> _runTask(BuildContext context, String? name) async {
    if (name == null) return;
    final l10n = AppLocalizations.of(context)!;
    await Injection.adminNotifier.runCronTask(name);
    if (context.mounted) {
      showFToast(context: context, title: Text(l10n.cronTriggeredParams(name)));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
