import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/package_notifier.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
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
    if (state is! PackageListLoaded) return [];
    final seen = <String>{};
    return state.packages.where((p) => seen.add(p.name ?? '')).toList();
  }

  bool get _loading =>
      Injection.packageNotifier.listState is PackageListLoading;

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

    return AppPage(
      title: l10n.packages,
      child: ListenableBuilder(
        listenable: Injection.packageNotifier,
        builder: (context, _) => _buildBody(l10n),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading && _packages.isEmpty) {
      return const AppLoading();
    }
    if (_error != null && _packages.isEmpty) {
      return AppError(message: _error!, onRetry: _loadPackages);
    }
    if (!_loading && _packages.isEmpty) {
      return AppEmpty(icon: FIcons.package, title: l10n.noPackages);
    }
    return _buildPackageList(l10n);
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
              child: FButton(
                variant: isSelected ? .primary : .outline,
                size: .xs,
                onPress: () {
                  setState(() => _typeFilter = type);
                  _loadPackages();
                },
                child: Text(type ?? l10n.allTypes),
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
    final theme = Theme.of(context);
    return FadeInWrapper(
      delay: Duration(milliseconds: index * 30),
      child: Padding(
        padding: const EdgeInsets.only(bottom: UIConstants.md),
        child: FCard.raw(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FTappable(
                onPress: () {
                  if (pkg.type != null &&
                      pkg.name != null &&
                      pkg.version != null) {
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
                child: Padding(
                  padding: const EdgeInsets.all(UIConstants.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FIcons.package,
                            size: UIConstants.iconLg,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: UIConstants.md),
                          Expanded(
                            child: Text(
                              pkg.name ?? '',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Icon(FIcons.chevronRight),
                        ],
                      ),
                      const SizedBox(height: UIConstants.sm + 2),
                      Wrap(
                        spacing: UIConstants.sm,
                        runSpacing: UIConstants.xs,
                        children: [
                          if (pkg.type != null) _buildTypeBadge(pkg.type!),
                          if (pkg.version != null)
                            _buildVersionBadge(pkg.version!),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (repo != null && repo.full_name != null)
                FTappable(
                  onPress: () {
                    final parts = repo.full_name!.split('/');
                    if (parts.length == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RepoDetailPage(owner: parts[0], repo: parts[1]),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      UIConstants.md,
                      0,
                      UIConstants.md,
                      UIConstants.md,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FIcons.code,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            repo.full_name!,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
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
