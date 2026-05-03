import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../state/admin_notifier.dart';

class AdminEmailsPage extends StatefulWidget {
  const AdminEmailsPage({super.key});

  @override
  State<AdminEmailsPage> createState() => _AdminEmailsPageState();
}

class _AdminEmailsPageState extends State<AdminEmailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Injection.adminNotifier.loadEmails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminEmailsTitle)),
      body: ListenableBuilder(
        listenable: Injection.adminNotifier,
        builder: (context, _) {
          final state = Injection.adminNotifier.emailsState;
          return switch (state) {
            AdminEmailsLoading() => const Center(child: CircularProgressIndicator()),
            AdminEmailsError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l10n.error}: $message'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Injection.adminNotifier.loadEmails(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
            AdminEmailsLoaded(:final emails) => emails.isEmpty
              ? Center(child: Text(l10n.adminNoEmails))
              : ListView.builder(
                  itemCount: emails.length,
                  itemBuilder: (context, index) {
                    final email = emails[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.email),
                        title: Text(email.email ?? l10n.unknown),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (email.username != null)
                              Text('${l10n.username}: ${email.username}'),
                            if (email.verified != null)
                              Text('Verified: ${email.verified! ? 'Yes' : 'No'}'),
                            if (email.primary != null)
                              Text('Primary: ${email.primary! ? 'Yes' : 'No'}'),
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
