import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminCronTitle)),
      body: ListenableBuilder(
        listenable: Injection.adminNotifier,
        builder: (context, _) {
          final state = Injection.adminNotifier.cronState;
          return switch (state) {
            AdminCronLoading() => const Center(child: CircularProgressIndicator()),
            AdminCronError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.adminNotifier.loadCronTasks(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            AdminCronLoaded(:final tasks) => tasks.isEmpty
              ? Center(child: Text(l10n.adminNoCron))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.schedule),
                        title: Text(task.name ?? l10n.unknown),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (task.schedule != null)
                              Text('${l10n.schedule}: ${task.schedule}'),
                            if (task.next != null)
                              Text('${l10n.next}: ${_formatDate(task.next!)}'),
                            if (task.exec_times != null)
                              Text('${l10n.executions}: ${task.exec_times}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_arrow),
                          tooltip: l10n.adminRunCron,
                          onPressed: () => _runTask(context, task.name),
                        ),
                      ),
                    );
                  },
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cronTriggeredParams(name))),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
