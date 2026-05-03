import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminPanel)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _AdminFeatureCard(
            icon: Icons.webhook,
            title: l10n.adminHooksTitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminHooksPage()),
              );
            },
          ),
          _AdminFeatureCard(
            icon: Icons.schedule,
            title: l10n.adminCronTitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminCronPage()),
              );
            },
          ),
          _AdminFeatureCard(
            icon: Icons.directions_run,
            title: l10n.adminRunnersTitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminRunnersPage()),
              );
            },
          ),
          _AdminFeatureCard(
            icon: Icons.email,
            title: l10n.adminEmailsTitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminEmailsPage()),
              );
            },
          ),
          _AdminFeatureCard(
            icon: Icons.badge,
            title: l10n.adminBadgesTitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminBadgesPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AdminFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AdminFeatureCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}
