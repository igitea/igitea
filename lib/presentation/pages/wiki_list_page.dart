import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/empty_state.dart';
import 'wiki_edit_page.dart';

class WikiListPage extends StatefulWidget {
  final String owner;
  final String repo;

  const WikiListPage({
    super.key,
    required this.owner,
    required this.repo,
  });

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
        builder: (_) => WikiEditPage(
          owner: widget.owner,
          repo: widget.repo,
        ),
      ),
    );
    if (result == true) {
      _loadPages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wiki)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createPage,
        icon: const Icon(Icons.add),
        label: Text(l10n.newWikiPage),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${l10n.error}: $_error'),
                      const SizedBox(height: UIConstants.md),
                      FilledButton(
                        onPressed: _loadPages,
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                )
              : _pages.isEmpty
                  ? EmptyState(
                      icon: Icons.book_outlined,
                      title: l10n.noWikiPages,
                      subtitle: l10n.noWikiPagesDescription,
                      action: FilledButton.icon(
                        onPressed: _createPage,
                        icon: const Icon(Icons.add),
                        label: Text(l10n.createFirstWikiPage),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadPages,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(UIConstants.md),
                        itemCount: _pages.length,
                        itemBuilder: (context, index) {
                          final page = _pages[index];
                          return FadeInWrapper(
                            delay: Duration(milliseconds: index * 30),
                            child: Card(
                              margin: const EdgeInsets.only(bottom: UIConstants.md),
                              child: ListTile(
                                leading: const Icon(Icons.article_outlined),
                                title: Text(
                                  page.title ?? l10n.untitled,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: page.last_commit != null
                                    ? Text(
                                        '${l10n.lastCommit}: ${page.last_commit!.sha ?? ''}',
                                        style: theme.textTheme.bodySmall,
                                      )
                                    : null,
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
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
                          );
                        },
                      ),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteWikiPage),
        content: Text(l10n.deleteWikiPageConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.error}: ${value.message}')),
          );
        case Right():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.wikiPageDeleted)),
          );
          Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageName),
        actions: [
          if (!_loading && _error == null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _editPage,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deletePage,
            ),
          ],
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${l10n.error}: $_error'),
                      const SizedBox(height: UIConstants.md),
                      FilledButton(
                        onPressed: _loadPage,
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
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
