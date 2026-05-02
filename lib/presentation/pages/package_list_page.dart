import 'package:flutter/material.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/package_notifier.dart';
import '../widgets/empty_state.dart';
import 'package_detail_page.dart';
import 'repo_detail_page.dart';

class PackageListPage extends StatefulWidget {
  final String owner;

  const PackageListPage({super.key, required this.owner});

  @override
  State<PackageListPage> createState() => _PackageListPageState();
}

class _PackageListPageState extends State<PackageListPage> {
  String? _typeFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPackages());
  }

  Future<void> _loadPackages() async {
    await Injection.packageNotifier.loadPackages(
      widget.owner,
      type: _typeFilter,
    );
  }

  List<Package> get _packages {
    final state = Injection.packageNotifier.listState;
    return state is PackageListLoaded ? state.packages : [];
  }

  bool get _loading => Injection.packageNotifier.listState is PackageListLoading;

  String? get _error {
    final state = Injection.packageNotifier.listState;
    return state is PackageListError ? state.message : null;
  }

  List<String> get _types {
    final types = <String>{};
    for (final p in _packages) {
      if (p.type != null) types.add(p.type!);
    }
    return types.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.packages)),
      body: ListenableBuilder(
        listenable: Injection.packageNotifier,
        builder: (context, _) => _buildBody(l10n),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading && _packages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _packages.isEmpty) {
      return _buildErrorState(l10n);
    }
    if (!_loading && _packages.isEmpty) {
      return EmptyState(
        icon: Icons.inventory_2_outlined,
        title: l10n.noPackages,
      );
    }
    return _buildPackageList(l10n);
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${l10n.error}: $_error'),
          const SizedBox(height: UIConstants.md),
          FilledButton(
            onPressed: _loadPackages,
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageList(AppLocalizations l10n) {
    final types = _types;
    return RefreshIndicator(
      onRefresh: _loadPackages,
      child: ListView.builder(
        padding: const EdgeInsets.all(UIConstants.md),
        itemCount: _packages.length + (types.length > 1 ? 1 : 0),
        itemBuilder: (context, index) {
          if (types.length > 1 && index == 0) {
            return _buildTypeFilter(l10n, types);
          }
          final pkgIndex = types.length > 1 ? index - 1 : index;
          final pkg = _packages[pkgIndex];
          return _buildPackageCard(l10n, pkg, pkgIndex);
        },
      ),
    );
  }

  Widget _buildTypeFilter(AppLocalizations l10n, List<String> types) {
    final allTypes = [null, ...types];
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: allTypes.map((type) {
            final isSelected = _typeFilter == type;
            return Padding(
              padding: const EdgeInsets.only(right: UIConstants.sm),
              child: FilterChip(
                label: Text(type ?? l10n.allTypes),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => _typeFilter = type);
                  _loadPackages();
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'npm':
        return const Color(0xFFCB3837);
      case 'pypi':
        return const Color(0xFF3775A9);
      case 'nuget':
        return const Color(0xFF004880);
      case 'maven':
        return const Color(0xFFC71A36);
      case 'container':
        return const Color(0xFF2496ED);
      case 'composer':
        return const Color(0xFF885630);
      case 'rubygems':
        return const Color(0xFFE9573F);
      case 'go':
        return const Color(0xFF00ADD8);
      case 'helm':
        return const Color(0xFF0F1689);
      default:
        return Theme.of(context).colorScheme.tertiary;
    }
  }

  Widget _buildPackageCard(AppLocalizations l10n, Package pkg, int index) {
    final repo = pkg.repository;
    return FadeInWrapper(
      delay: Duration(milliseconds: index * 30),
      child: Card(
        margin: const EdgeInsets.only(bottom: UIConstants.md),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: InkWell(
          onTap: () {
            if (pkg.type != null && pkg.name != null && pkg.version != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PackageDetailPage(
                    owner: widget.owner,
                    type: pkg.type!,
                    name: pkg.name!,
                    version: pkg.version!,
                  ),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(UIConstants.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: UIConstants.iconLg,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: UIConstants.md),
                    Expanded(
                      child: Text(
                        pkg.name ?? '',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                const SizedBox(height: UIConstants.sm + 2),
                Wrap(
                  spacing: UIConstants.sm,
                  runSpacing: UIConstants.xs,
                  children: [
                    if (pkg.type != null)
                      _buildTypeBadge(pkg.type!),
                    if (pkg.version != null)
                      _buildVersionBadge(pkg.version!),
                  ],
                ),
                if (repo != null && repo.full_name != null) ...[
                  const SizedBox(height: UIConstants.sm),
                  InkWell(
                    onTap: () {
                      final parts = repo.full_name!.split('/');
                      if (parts.length == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RepoDetailPage(
                              owner: parts[0],
                              repo: parts[1],
                            ),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.code,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              repo.full_name!,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _typeColor(type).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: _typeColor(type),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVersionBadge(String version) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        version,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
