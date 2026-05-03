import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/org_avatar.dart';
import '../widgets/premium_card.dart';
import 'organization_detail_page.dart';

class OrganizationsListPage extends StatelessWidget {
  final List<Organization> orgs;

  const OrganizationsListPage({super.key, required this.orgs});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.organisations),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: UIConstants.xl),
        itemCount: orgs.length,
        itemBuilder: (context, index) {
          final org = orgs[index];
          return FadeInWrapper(
            delay: Duration(milliseconds: index * 30),
            child: _OrgItem(org: org),
          );
        },
      ),
    );
  }
}

class _OrgItem extends StatelessWidget {
  final Organization org;

  const _OrgItem({required this.org});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: UIConstants.pagePadding,
      child: PremiumCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrganizationDetailPage(
                orgName: [org.username, org.name]
                  .whereType<String>()
                  .where((s) => s.isNotEmpty)
                  .firstOrNull ?? '',
              ),
            ),
          );
        },
        child: Row(
          children: [
            OrgAvatar(org: org, radius: UIConstants.avatarLg),
            const SizedBox(width: UIConstants.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [org.full_name, org.name, org.username]
                      .whereType<String>()
                      .where((s) => s.isNotEmpty)
                      .firstOrNull ?? '',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (org.description != null && org.description!.isNotEmpty) ...[
                    const SizedBox(height: UIConstants.xs),
                    Text(
                      org.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }
}
