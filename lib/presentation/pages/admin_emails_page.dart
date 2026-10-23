import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_tile.dart';
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
    return AppPage(
      title: l10n.adminEmailsTitle,
      child: ListenableBuilder(
        listenable: Injection.adminNotifier,
        builder: (context, _) {
          final state = Injection.adminNotifier.emailsState;
          return switch (state) {
            AdminEmailsLoading() => const AppLoading(),
            AdminEmailsError(:final message) => AppError(
              message: message,
              onRetry: () => Injection.adminNotifier.loadEmails(),
            ),
            AdminEmailsLoaded(:final emails) => emails.isEmpty
              ? AppEmpty(icon: FIcons.mail, title: l10n.adminNoEmails)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  children: [
                    AppSection(
                      title: '',
                      showHeader: false,
                      children: [
                        for (final email in emails)
                          AppTile(
                            leading: const Icon(FIcons.mail),
                            title: email.email ?? l10n.unknown,
                            subtitle: [
                              if (email.username != null)
                                '${l10n.username}: ${email.username}',
                              if (email.verified != null)
                                'Verified: ${email.verified! ? 'Yes' : 'No'}',
                              if (email.primary != null)
                                'Primary: ${email.primary! ? 'Yes' : 'No'}',
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
