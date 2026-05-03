import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../state/admin_notifier.dart';

class AdminBadgesPage extends StatefulWidget {
  const AdminBadgesPage({super.key});

  @override
  State<AdminBadgesPage> createState() => _AdminBadgesPageState();
}

class _AdminBadgesPageState extends State<AdminBadgesPage> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminBadgesTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: l10n.adminBadgeUsername,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () {
                    final username = _usernameController.text.trim();
                    if (username.isNotEmpty) {
                      Injection.adminNotifier.loadBadges(username);
                    }
                  },
                  child: Text(l10n.search),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: Injection.adminNotifier,
              builder: (context, _) {
                final state = Injection.adminNotifier.badgesState;
                return switch (state) {
                  AdminBadgesLoading() => const Center(child: CircularProgressIndicator()),
                  AdminBadgesError(:final message) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${l10n.error}: $message'),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            final username = _usernameController.text.trim();
                            if (username.isNotEmpty) {
                              Injection.adminNotifier.loadBadges(username);
                            }
                          },
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                  AdminBadgesLoaded(:final badges) => badges.isEmpty
                    ? Center(child: Text(l10n.adminNoBadges))
                    : ListView.builder(
                        itemCount: badges.length,
                        itemBuilder: (context, index) {
                          final badge = badges[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: ListTile(
                              leading: badge.image_url != null
                                ? Image.network(badge.image_url!, width: 40, height: 40, errorBuilder: (context, error, stackTrace) => const Icon(Icons.badge))
                                : const Icon(Icons.badge),
                              title: Text(badge.slug ?? l10n.unknown),
                              subtitle: badge.description != null ? Text(badge.description!) : null,
                            ),
                          );
                        },
                      ),
                  _ => const Center(child: Text('Enter a username to view badges')),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
