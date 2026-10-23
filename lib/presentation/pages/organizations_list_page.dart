import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import '../widgets/org_avatar.dart';
import 'organization_detail_page.dart';

class OrganizationsListPage extends StatelessWidget {
  final List<Organization> orgs;

  const OrganizationsListPage({super.key, required this.orgs});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPage(
      title: l10n.organisations,
      child: orgs.isEmpty
          ? AppEmpty(icon: FIcons.building2, title: l10n.noData)
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: orgs.length,
              itemBuilder: (context, index) {
                final org = orgs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FCard.raw(
                    child: AppTile(
                      leading: OrgAvatar(
                        org: org,
                        radius: UIConstants.avatarLg,
                      ),
                      title:
                          [org.full_name, org.name, org.username]
                              .whereType<String>()
                              .where((s) => s.isNotEmpty)
                              .firstOrNull ??
                          '',
                      subtitle: org.description,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrganizationDetailPage(
                              orgName:
                                  [org.username, org.name]
                                      .whereType<String>()
                                      .where((s) => s.isNotEmpty)
                                      .firstOrNull ??
                                  '',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
