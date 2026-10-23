import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:forui/forui.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
import '../widgets/forui/app_tile.dart';
import 'wiki_edit_page.dart';

class WikiListPage extends StatefulWidget {
  final String owner;
  final String repo;

  const WikiListPage({super.key, required this.owner, required this.repo});

  @override
  State<WikiListPage> createState() => _WikiListPageState();
}

class _WikiListPageState extends State<WikiListPage> {
  List<WikiPageMetaData> _pages = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  Future<void> _loadPages() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await Injection.repoNotifier.listWikiPages(
      widget.owner,
      widget.repo,
    );

    if (mounted) {
      switch (result) {
        case Left(:final value):
          setState(() {
            _error = value.message;
            _loading = false;
          });
        case Right(:final value):
          setState(() {
            _pages = value;
            _loading = false;
          });
      }
    }
  }

  Future<void> _createPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WikiEditPage(owner: widget.owner, repo: widget.repo),
      ),
    );
    if (result == true) {
      _loadPages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      title: l10n.wiki,
      actions: [
        FHeaderAction(
          icon: const Icon(FIcons.plus),
          semanticsLabel: l10n.newWikiPage,
          onPress: _createPage,
        ),
      ],
      child: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) {
      return const AppLoading();
    }
    if (_error != null) {
      return AppError(message: _error!, onRetry: _loadPages);
    }
    if (_pages.isEmpty) {
      return AppEmpty(
        icon: FIcons.bookOpen,
        title: l10n.noWikiPages,
        subtitle: l10n.noWikiPagesDescription,
        action: FButton(
          prefix: const Icon(FIcons.plus, size: 16),
          onPress: _createPage,
          child: Text(l10n.createFirstWikiPage),
        ),
      );
    }
    return _buildPageList(l10n);
  }

  Widget _buildPageList(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: _loadPages,
      child: ListView.builder(
        padding: const EdgeInsets.all(UIConstants.md),
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          final page = _pages[index];
          return FadeInWrapper(
            delay: Duration(milliseconds: index * 30),
            child: Padding(
              padding: const EdgeInsets.only(bottom: UIConstants.md),
              child: FCard.raw(
                child: AppTile(
                  leading: Icon(
                    FIcons.bookText,
                    size: UIConstants.iconMd,
                    color: theme.colorScheme.primary,
                  ),
                  title: page.title ?? l10n.untitled,
                  subtitle: page.last_commit != null
                      ? '${l10n.lastCommit}: ${page.last_commit!.sha ?? ''}'
                      : null,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WikiDetailPage(
                          owner: widget.owner,
                          repo: widget.repo,
                          pageName: page.title ?? '',
                        ),
                      ),
                    ).then((_) => _loadPages());
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WikiDetailPage extends StatefulWidget {
  final String owner;
  final String repo;
  final String pageName;

  const WikiDetailPage({
    super.key,
    required this.owner,
    required this.repo,
    required this.pageName,
  });

  @override
  State<WikiDetailPage> createState() => _WikiDetailPageState();
}

class _WikiDetailPageState extends State<WikiDetailPage> {
  WikiPage? _page;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await Injection.repoNotifier.getWikiPage(
      widget.owner,
      widget.repo,
      widget.pageName,
    );

    if (mounted) {
      switch (result) {
        case Left(:final value):
          setState(() {
            _error = value.message;
            _loading = false;
          });
        case Right(:final value):
          setState(() {
            _page = value;
            _loading = false;
          });
      }
    }
  }

  Future<void> _editPage() async {
    final content = _page?.content_base64 != null
        ? utf8.decode(base64Decode(_page!.content_base64!))
        : '';

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WikiEditPage(
          owner: widget.owner,
          repo: widget.repo,
          pageName: widget.pageName,
          initialContent: content,
        ),
      ),
    );

    if (result == true) {
      _loadPage();
    }
  }

  Future<void> _deletePage() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        title: Text(l10n.deleteWikiPage),
        body: Text(l10n.deleteWikiPageConfirm),
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

    if (confirmed != true) return;

    final result = await Injection.repoNotifier.deleteWikiPage(
      widget.owner,
      widget.repo,
      widget.pageName,
    );

    if (mounted) {
      switch (result) {
        case Left(:final value):
          showFToast(
            context: context,
            variant: .destructive,
            title: Text('${l10n.error}: ${value.message}'),
          );
        case Right():
          showFToast(context: context, title: Text(l10n.wikiPageDeleted));
          Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      title: widget.pageName,
      actions: [
        if (!_loading && _error == null) ...[
          FHeaderAction(
            icon: const Icon(FIcons.pencil),
            semanticsLabel: l10n.edit,
            onPress: _editPage,
          ),
          FHeaderAction(
            icon: const Icon(FIcons.trash2),
            semanticsLabel: l10n.delete,
            onPress: _deletePage,
          ),
        ],
      ],
      child: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) {
      return const AppLoading();
    }
    if (_error != null) {
      return AppError(message: _error!, onRetry: _loadPage);
    }
    return FadeInWrapper(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.md),
        child: MarkdownBody(
          data: _page?.content_base64 != null
              ? utf8.decode(base64Decode(_page!.content_base64!))
              : l10n.noContent,
          selectable: true,
        ),
      ),
    );
  }
}
