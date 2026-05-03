import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminRunnersTitle)),
      body: ListenableBuilder(
        listenable: Injection.adminNotifier,
        builder: (context, _) {
          final state = Injection.adminNotifier.runnersState;
          return switch (state) {
            AdminRunnersLoading() => const Center(child: CircularProgressIndicator()),
            AdminRunnersError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.adminNotifier.loadRunners(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            AdminRunnersLoaded(:final runners) => runners.isEmpty
              ? Center(child: Text(l10n.adminNoRunners))
              : ListView.builder(
                  itemCount: runners.length,
                  itemBuilder: (context, index) {
                    final runner = runners[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.directions_run),
                        title: Text(runner.name ?? l10n.unknown),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (runner.status != null)
                              Text('Status: ${runner.status}'),
                            if (runner.busy != null)
                              Text('Busy: ${runner.busy! ? 'Yes' : 'No'}'),
                          ],
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
}
