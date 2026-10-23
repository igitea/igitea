import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/package_notifier.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_section.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
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

  String get _host {
    final uri = Uri.tryParse(Injection.apiClient.baseUrl);
    return uri?.host ?? 'host';
  }

  String get _baseUrl {
    return Injection.apiClient.baseUrl.replaceAll(RegExp(r'/+$'), '');
  }

  String _installCommand() {
    final n = widget.name;
    final v = widget.version;
    final h = _host;
    final b = _baseUrl;
    final o = widget.owner;
    switch (widget.type.toLowerCase()) {
      case 'npm':
        return 'npm config set @$o:registry $b/api/packages/$o/npm/\n'
            'npm install @$o/$n@$v';
      case 'pypi':
        return 'pip install --index-url $b/api/packages/$o/pypi/simple/ $n==$v';
      case 'nuget':
        return 'dotnet nuget add source $b/api/packages/$o/nuget/index.json\n'
            'dotnet add package $n --version $v';
      case 'maven':
        return '<repository>\n'
            '  <id>gitea</id>\n'
            '  <url>$b/api/packages/$o/maven</url>\n'
            '</repository>\n\n'
            '<dependency>\n'
            '  <groupId>...</groupId>\n'
            '  <artifactId>$n</artifactId>\n'
            '  <version>$v</version>\n'
            '</dependency>';
      case 'composer':
        return 'composer config repo.$n composer $b/api/packages/$o/composer\n'
            'composer require $n:$v';
      case 'rubygems':
        return 'gem install $n -v $v --source $b/api/packages/$o/rubygems';
      case 'go':
        return 'GOPROXY=$b/api/packages/$o/go go get $n@$v';
      case 'container':
        return 'docker pull $h/$n:$v';
      case 'helm':
        return 'helm repo add $n $b/api/packages/$o/helm\n'
            'helm install $n --version $v';
      case 'conan':
        return 'conan remote add $n $b/api/packages/$o/conan\n'
            'conan install $n/$v@';
      case 'conda':
        return 'conda config --add channels $b/api/packages/$o/conda\n'
            'conda install $n=$v';
      case 'cran':
        return 'install.packages("$n", repos="$b/api/packages/$o/cran")';
      case 'debian':
        return 'curl -s $b/api/packages/$o/debian/pool/$n/$v/$n.deb | sudo apt install';
      case 'generic':
        return 'curl -O $b/api/packages/$o/generic/$n/$v/<file>';
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

  int get _totalSize => _files.fold<int>(0, (sum, f) => sum + (f.size ?? 0));

  Future<void> _deletePackage() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deletePackage),
        body: Text(l10n.deletePackageConfirm),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.pop(ctx, true),
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
          showFToast(context: context, title: Text(l10n.packageDeleted));
          Navigator.pop(context, true);
        } else {
          showFToast(
            context: context,
            variant: .destructive,
            title: Text(l10n.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: widget.name,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.trash2),
          semanticsLabel: AppLocalizations.of(context)!.deletePackage,
          onPress: _deletePackage,
        ),
      ],
      child: ListenableBuilder(
        listenable: Injection.packageNotifier,
        builder: (context, _) => _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return const AppLoading();
    }
    if (_error != null) {
      return AppError(message: _error!, onRetry: _loadDetail);
    }
    final pkg = _package;
    if (pkg == null) {
      return const SizedBox.shrink();
    }
    return _buildDetailContent(l10n, pkg);
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
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            FIcons.package,
            color: theme.colorScheme.onPrimaryContainer,
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
                style: theme.textTheme.headlineSmall?.copyWith(
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
                  style: theme.textTheme.labelSmall?.copyWith(
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
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: _buildSummaryGrid(l10n, pkg),
      ),
    );
  }

  Widget _buildSummaryGrid(AppLocalizations l10n, Package pkg) {
    final theme = Theme.of(context);
    final items = <(IconData, String, String)>[
      (FIcons.tag, l10n.packageVersion, widget.version),
    ];
    if (pkg.creator != null) {
      items.add((FIcons.user, l10n.packageCreator, pkg.creator!.login ?? '—'));
    }
    if (pkg.created_at != null) {
      items.add((
        FIcons.calendar,
        l10n.packageCreated,
        _formatDate(pkg.created_at!),
      ));
    }
    if (_files.isNotEmpty) {
      items.add((FIcons.fileText, l10n.packageFiles, '${_files.length}'));
      items.add((FIcons.hardDrive, l10n.totalSize, _formatSize(_totalSize)));
    }

    return Wrap(
      spacing: UIConstants.md,
      runSpacing: UIConstants.sm,
      children: items.map((item) {
        final (icon, label, value) = item;
        return SizedBox(
          width:
              (MediaQuery.of(context).size.width - 64) / 2 - UIConstants.md / 2,
          child: Row(
            children: [
              Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
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
    final theme = Theme.of(context);
    final command = _installCommand();
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.installation,
              style: theme.textTheme.titleMedium?.copyWith(
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
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      command,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  const SizedBox(width: UIConstants.sm),
                  FTappable(
                    onPress: () {
                      Clipboard.setData(ClipboardData(text: command));
                      showFToast(context: context, title: Text(l10n.copied));
                    },
                    semanticsLabel: l10n.copy,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        FIcons.copy,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
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
    final theme = Theme.of(context);
    final url = _packageWebUrl();
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.packageUrl,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: UIConstants.md),
            Row(
              children: [
                Icon(
                  FIcons.externalLink,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: UIConstants.sm),
                Flexible(
                  child: Text(
                    url,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: UIConstants.sm),
                FTappable(
                  onPress: () {
                    Clipboard.setData(ClipboardData(text: url));
                    showFToast(context: context, title: Text(l10n.copied));
                  },
                  semanticsLabel: l10n.copy,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      FIcons.copy,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionsSection(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final versions = _versions;
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.versions,
              style: theme.textTheme.titleMedium?.copyWith(
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
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ...versions.map((v) => _buildVersionItem(l10n, v)),
            if (_versionsLoadingMore)
              const Padding(
                padding: EdgeInsets.all(UIConstants.sm),
                child: Center(child: FCircularProgress(size: .sm)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionItem(AppLocalizations l10n, Package v) {
    final theme = Theme.of(context);
    final isCurrent = v.version == widget.version;
    return FTappable(
      onPress: isCurrent
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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: UIConstants.sm,
          horizontal: UIConstants.xs,
        ),
        child: Row(
          children: [
            Icon(
              isCurrent ? FIcons.circleDot : FIcons.circle,
              size: 16,
              color: isCurrent
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: UIConstants.sm),
            Expanded(
              child: Text(
                v.version ?? '—',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                  color: isCurrent ? theme.colorScheme.primary : null,
                ),
              ),
            ),
            if (v.created_at != null)
              Text(
                _formatDateShort(v.created_at!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepoSection(AppLocalizations l10n, Package pkg) {
    final theme = Theme.of(context);
    final repo = pkg.repository!;
    final fullName = repo.full_name ?? repo.name ?? '—';
    return FCard.raw(
      child: FTappable(
        onPress: () {
          final parts = fullName.split('/');
          if (parts.length == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RepoDetailPage(owner: parts[0], repo: parts[1]),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.packageRepository,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: UIConstants.md),
              Row(
                children: [
                  Icon(
                    FIcons.code,
                    size: UIConstants.iconMd,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: UIConstants.sm),
                  Expanded(
                    child: Text(
                      fullName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    FIcons.chevronRight,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              if (repo.description != null && repo.description!.isNotEmpty) ...[
                const SizedBox(height: UIConstants.sm),
                Text(
                  repo.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
    if (_files.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.packageFiles,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: UIConstants.sm),
          AppEmpty(icon: FIcons.fileText, title: l10n.noData),
        ],
      );
    }
    return AppSection(
      title: l10n.packageFiles,
      children: _files.map(_buildFileTile).toList(),
    );
  }

  Widget _buildFileTile(PackageFile file) {
    final theme = Theme.of(context);
    return AppTile(
      leading: Icon(
        FIcons.fileText,
        size: UIConstants.iconMd,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      title: file.name ?? '—',
      showChevron: false,
      trailing: file.size != null
          ? Text(
              _formatSize(file.size!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      onPress: null,
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
