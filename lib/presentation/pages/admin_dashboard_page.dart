import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_tile.dart';
import 'admin_badges_page.dart';
import 'admin_cron_page.dart';
import 'admin_emails_page.dart';
import 'admin_hooks_page.dart';
import 'admin_runners_page.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      title: l10n.adminPanel,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          AppSection(
            title: '',
            showHeader: false,
            children: [
              AppTile(
                leading: const Icon(FIcons.webhook),
                title: l10n.adminHooksTitle,
                onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminHooksPage()),
                ),
              ),
              AppTile(
                leading: const Icon(FIcons.calendarClock),
                title: l10n.adminCronTitle,
                onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminCronPage()),
                ),
              ),
              AppTile(
                leading: const Icon(FIcons.activity),
                title: l10n.adminRunnersTitle,
                onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminRunnersPage()),
                ),
              ),
              AppTile(
                leading: const Icon(FIcons.mail),
                title: l10n.adminEmailsTitle,
                onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminEmailsPage()),
                ),
              ),
              AppTile(
                leading: const Icon(FIcons.badgeCheck),
                title: l10n.adminBadgesTitle,
                onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminBadgesPage()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
