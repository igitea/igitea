import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/animations/animated_wrapper.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';

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

    try {
      final result = await Injection.apiService.repoGetWikiPages(
        owner: widget.owner,
        repo: widget.repo,
      );
      if (mounted) {
        setState(() {
          _pages = result;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Wiki')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: $_error'),
                      const SizedBox(height: UIConstants.md),
                      FilledButton(
                        onPressed: _loadPages,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _pages.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.book_outlined, size: 64),
                          SizedBox(height: 16),
                          Text('No wiki pages yet'),
                        ],
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
                                  page.title ?? 'Untitled',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: page.last_commit != null
                                    ? Text(
                                        'Last commit: ${page.last_commit!.sha ?? ''}',
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
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    return 'just now';
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

    try {
      final result = await Injection.apiService.repoGetWikiPage(
        owner: widget.owner,
        repo: widget.repo,
        pageName: widget.pageName,
      );
      if (mounted) {
        setState(() {
          _page = result;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageName),
        actions: [
          if (_page?.html_url != null)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {
                // Open in browser
              },
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: $_error'),
                      const SizedBox(height: UIConstants.md),
                      FilledButton(
                        onPressed: _loadPage,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(UIConstants.md),
                  child: MarkdownBody(
                    data: _page?.content_base64 != null
                        ? utf8.decode(base64Decode(_page!.content_base64!))
                        : 'No content',
                  ),
                ),
    );
  }
}
