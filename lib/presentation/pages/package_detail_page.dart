import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/package_notifier.dart';
import '../widgets/empty_state.dart';
import 'repo_detail_page.dart';

class PackageDetailPage extends StatefulWidget {
  final String owner;
  final String type;
  final String name;
  final String version;

  const PackageDetailPage({
    super.key,
    required this.owner,
    required this.type,
    required this.name,
    required this.version,
  });

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> {
  final _versionScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
      _loadVersions();
    });
    _versionScrollController.addListener(_onVersionScroll);
  }

  @override
  void dispose() {
    _versionScrollController.dispose();
    super.dispose();
  }

  void _loadDetail() {
    Injection.packageNotifier.loadPackageDetail(
      owner: widget.owner,
      type: widget.type,
      name: widget.name,
      version: widget.version,
    );
  }

  void _loadVersions() async {
    await Injection.packageNotifier.loadVersions(
      owner: widget.owner,
      type: widget.type,
      name: widget.name,
    );
  }

  void _onVersionScroll() {
    if (_versionScrollController.position.pixels >=
        _versionScrollController.position.maxScrollExtent - 100) {
      Injection.packageNotifier.loadMoreVersions(
        owner: widget.owner,
        type: widget.type,
        name: widget.name,
      );
    }
  }

  Package? get _package {
    final state = Injection.packageNotifier.detailState;
    return state is PackageDetailLoaded ? state.package : null;
  }

  List<PackageFile> get _files {
    final state = Injection.packageNotifier.detailState;
    return state is PackageDetailLoaded ? state.files : [];
  }

  List<Package> get _versions => Injection.packageNotifier.versions;

  bool get _loading =>
      Injection.packageNotifier.detailState is PackageDetailLoading;

  bool get _versionsLoadingMore => Injection.packageNotifier.versionsLoading;

  String? get _error {
    final state = Injection.packageNotifier.detailState;
    return state is PackageDetailError ? state.message : null;
  }

  String _installCommand() {
    final n = widget.name;
    final v = widget.version;
    switch (widget.type.toLowerCase()) {
      case 'npm':
        return 'npm install $n@$v';
      case 'pypi':
        return 'pip install $n==$v';
      case 'nuget':
        return 'dotnet add package $n --version $v';
      case 'maven':
        return '<dependency>\n  <groupId>...</groupId>\n  <artifactId>$n</artifactId>\n  <version>$v</version>\n</dependency>';
      case 'composer':
        return 'composer require $n:$v';
      case 'rubygems':
        return 'gem install $n -v $v';
      case 'go':
        return 'go get $n@$v';
      case 'container':
        return 'docker pull $n:$v';
      case 'helm':
        return 'helm install $n --version $v';
      case 'conan':
        return 'conan install $n/$v@';
      case 'conda':
        return 'conda install $n=$v';
      case 'cran':
        return 'install.packages("$n")';
      case 'debian':
        return 'apt install $n=$v';
      case 'generic':
        return '$n @ $v';
      default:
        return '$widget.type: $n@$v';
    }
  }

  String _packageWebUrl() {
    final pkg = _package;
    if (pkg != null && pkg.html_url != null) {
      return pkg.html_url!;
    }
    final baseUrl = Injection.apiClient.baseUrl.replaceAll(RegExp(r'/+$'), '');
    return '$baseUrl/${widget.owner}/-/packages/${widget.type}/${widget.name}';
  }

  int get _totalSize =>
      _files.fold<int>(0, (sum, f) => sum + (f.size ?? 0));

  Future<void> _deletePackage() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deletePackage),
        content: Text(l10n.deletePackageConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await Injection.packageNotifier.deletePackageVersion(
        owner: widget.owner,
        type: widget.type,
        name: widget.name,
        version: widget.version,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.packageDeleted)),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.error)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: AppLocalizations.of(context)!.deletePackage,
            onPressed: _deletePackage,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Injection.packageNotifier,
        builder: (context, _) => _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _buildErrorState(l10n);
    }
    final pkg = _package;
    if (pkg == null) {
      return const SizedBox.shrink();
    }
    return _buildDetailContent(l10n, pkg);
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${l10n.error}: $_error'),
          const SizedBox(height: UIConstants.md),
          FilledButton(
            onPressed: _loadDetail,
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContent(AppLocalizations l10n, Package pkg) {
    return ListView(
      padding: const EdgeInsets.all(UIConstants.md),
      children: [
        _buildHeader(l10n),
        const SizedBox(height: UIConstants.md),
        _buildSummarySection(l10n, pkg),
        const SizedBox(height: UIConstants.lg),
        _buildInstallSection(l10n),
        const SizedBox(height: UIConstants.lg),
        _buildMirrorsSection(l10n),
        const SizedBox(height: UIConstants.lg),
        _buildVersionsSection(l10n),
        const SizedBox(height: UIConstants.lg),
        if (pkg.repository != null) ...[
          _buildRepoSection(l10n, pkg),
          const SizedBox(height: UIConstants.lg),
        ],
        _buildFilesSection(l10n),
      ],
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.inventory_2_outlined,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: UIConstants.iconLg,
          ),
        ),
        const SizedBox(width: UIConstants.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: UIConstants.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _typeColor(widget.type).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.type,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _typeColor(widget.type),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection(AppLocalizations l10n, Package pkg) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: _buildSummaryGrid(l10n, pkg),
      ),
    );
  }

  Widget _buildSummaryGrid(AppLocalizations l10n, Package pkg) {
    final items = <(IconData, String, String)>[
      (Icons.tag, l10n.packageVersion, widget.version),
    ];
    if (pkg.creator != null) {
      items.add((Icons.person_outline, l10n.packageCreator, pkg.creator!.login ?? '—'));
    }
    if (pkg.created_at != null) {
      items.add((Icons.calendar_today_outlined, l10n.packageCreated, _formatDate(pkg.created_at!)));
    }
    if (_files.isNotEmpty) {
      items.add((Icons.insert_drive_file_outlined, l10n.packageFiles, '${_files.length}'));
      items.add((Icons.storage_outlined, l10n.totalSize, _formatSize(_totalSize)));
    }

    return Wrap(
      spacing: UIConstants.md,
      runSpacing: UIConstants.sm,
      children: items.map((item) {
        final (icon, label, value) = item;
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 64) / 2 - UIConstants.md / 2,
          child: Row(
            children: [
              Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInstallSection(AppLocalizations l10n) {
    final command = _installCommand();
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.installation,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: UIConstants.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.md,
                vertical: UIConstants.sm + 4,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      command,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  const SizedBox(width: UIConstants.sm),
                  IconButton(
                    icon: Icon(
                      Icons.copy_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    tooltip: l10n.copy,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: command));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.copied)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMirrorsSection(AppLocalizations l10n) {
    final url = _packageWebUrl();
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.packageUrl,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: UIConstants.md),
            Row(
              children: [
                Icon(Icons.open_in_browser, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: UIConstants.sm),
                Flexible(
                  child: Text(
                    url,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: UIConstants.sm),
                IconButton(
                  icon: Icon(
                    Icons.copy_outlined,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  tooltip: l10n.copy,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: url));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.copied)),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionsSection(AppLocalizations l10n) {
    final versions = _versions;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.versions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: UIConstants.sm),
            if (versions.isEmpty && !_versionsLoadingMore)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: UIConstants.md),
                child: Center(
                  child: Text(
                    l10n.noVersions,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ...versions.map((v) => _buildVersionItem(l10n, v)),
            if (_versionsLoadingMore)
              const Padding(
                padding: EdgeInsets.all(UIConstants.sm),
                child: Center(child: SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionItem(AppLocalizations l10n, Package v) {
    final isCurrent = v.version == widget.version;
    return InkWell(
      onTap: isCurrent
          ? null
          : () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PackageDetailPage(
                    owner: widget.owner,
                    type: widget.type,
                    name: widget.name,
                    version: v.version ?? '',
                  ),
                ),
              );
            },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: UIConstants.sm, horizontal: UIConstants.xs),
        child: Row(
          children: [
            Icon(
              isCurrent ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 16,
              color: isCurrent
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: UIConstants.sm),
            Expanded(
              child: Text(
                v.version ?? '—',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                  color: isCurrent
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
            ),
            if (v.created_at != null)
              Text(
                _formatDateShort(v.created_at!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepoSection(AppLocalizations l10n, Package pkg) {
    final repo = pkg.repository!;
    final fullName = repo.full_name ?? repo.name ?? '—';
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: () {
          final parts = fullName.split('/');
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.packageRepository,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: UIConstants.md),
              Row(
                children: [
                  Icon(
                    Icons.code,
                    size: UIConstants.iconMd,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: UIConstants.sm),
                  Expanded(
                    child: Text(
                      fullName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              if (repo.description != null && repo.description!.isNotEmpty) ...[
                const SizedBox(height: UIConstants.sm),
                Text(
                  repo.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilesSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.packageFiles,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: UIConstants.sm),
        if (_files.isEmpty)
          EmptyState(
            icon: Icons.insert_drive_file_outlined,
            title: l10n.noData,
          )
        else
          ..._files.map(_buildFileItem),
      ],
    );
  }

  Widget _buildFileItem(PackageFile file) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: UIConstants.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.md,
          vertical: UIConstants.sm + 4,
        ),
        child: Row(
          children: [
            Icon(
              Icons.insert_drive_file_outlined,
              size: UIConstants.iconMd,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: UIConstants.sm),
            Expanded(
              child: Text(
                file.name ?? '—',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (file.size != null)
              Text(
                _formatSize(file.size!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
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

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateShort(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
