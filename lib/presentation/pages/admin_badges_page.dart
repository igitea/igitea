import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_tile.dart';
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
    return AppPage(
      title: l10n.adminBadgesTitle,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: FTextField(
                    control: FTextFieldControl.managed(
                      controller: _usernameController,
                    ),
                    label: Text(l10n.adminBadgeUsername),
                  ),
                ),
                const SizedBox(width: 12),
                FButton(
                  onPress: () {
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
                  AdminBadgesLoading() => const AppLoading(),
                  AdminBadgesError(:final message) => AppError(
                    message: message,
                    onRetry: () {
                      final username = _usernameController.text.trim();
                      if (username.isNotEmpty) {
                        Injection.adminNotifier.loadBadges(username);
                      }
                    },
                  ),
                  AdminBadgesLoaded(:final badges) => badges.isEmpty
                    ? AppEmpty(icon: FIcons.badgeCheck, title: l10n.adminNoBadges)
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        children: [
                          AppSection(
                            title: '',
                            showHeader: false,
                            children: [
                              for (final badge in badges)
                                AppTile(
                                  leading: badge.image_url != null
                                      ? Image.network(
                                          badge.image_url!,
                                          width: 32,
                                          height: 32,
                                          cacheWidth: 64,
                                          cacheHeight: 64,
                                          errorBuilder: (_, _, _) =>
                                              const Icon(FIcons.badgeCheck),
                                        )
                                      : const Icon(FIcons.badgeCheck),
                                  title: badge.slug ?? l10n.unknown,
                                  subtitle: badge.description,
                                  showChevron: false,
                                  onPress: null,
                                ),
                            ],
                          ),
                        ],
                      ),
                  _ => const AppEmpty(
                    icon: FIcons.badgeCheck,
                    title: 'Enter a username to view badges',
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
