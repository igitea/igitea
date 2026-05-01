import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/all.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/repo_usecases.dart';
import '../../l10n/app_localizations.dart';
import 'file_history_page.dart';
import 'file_compare_page.dart';
import 'file_blame_page.dart';

class RepoFilePage extends StatefulWidget {
  final String owner;
  final String repo;
  final String path;
  final String name;
  final String? downloadUrl;
  final String? htmlUrl;
  final String? ref;

  const RepoFilePage({
    super.key,
    required this.owner,
    required this.repo,
    required this.path,
    required this.name,
    this.downloadUrl,
    this.htmlUrl,
    this.ref,
  });

  @override
  State<RepoFilePage> createState() => _RepoFilePageState();
}

class _RepoFilePageState extends State<RepoFilePage> {
  bool _loading = true;
  String? _error;
  String? _decodedContent;
  String? _originalContent;
  ContentsResponse? _rawResponse;
  bool _isEditing = false;
  bool _hasChanges = false;
  CodeController? _editController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFile();
    });
  }

  @override
  void dispose() {
    _editController?.removeListener(_onTextChanged);
    _editController?.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (!_isEditing || _editController == null) return;
    final hasChanges = _editController!.text != _originalContent;
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  static final _whitespaceRe = RegExp(r'\s');

  Future<void> _loadFile() async {
    final result = await Injection.getRepoContentsUseCase(
      GetRepoContentsParams(
        owner: widget.owner,
        repo: widget.repo,
        path: widget.path,
        ref: widget.ref,
      ),
    );
    if (!mounted) return;
    switch (result) {
      case Left<Failure, List<ContentsResponse>>(:final value):
        setState(() {
          _loading = false;
          _error = value.message;
        });
      case Right<Failure, List<ContentsResponse>>(:final value):
        if (value.isNotEmpty) {
          final item = value.first;
          String? decoded;
          if (item.content != null) {
            try {
              final cleaned = item.content!.replaceAll(_whitespaceRe, '');
              decoded = utf8.decode(base64Decode(cleaned));
            } catch (_) {
              decoded = null;
            }
          }
          setState(() {
            _rawResponse = item;
            _decodedContent = decoded;
            _originalContent = decoded;
            _loading = false;
          });
        } else {
          setState(() {
            _loading = false;
            _error = AppLocalizations.of(context)!.fileNotFound;
          });
        }
    }
  }

  bool get _isImage {
    final ext = _fileExtension.toLowerCase();
    return [
      'png',
      'jpg',
      'jpeg',
      'gif',
      'svg',
      'webp',
      'ico',
      'bmp',
    ].contains(ext);
  }

  bool get _isMarkdown {
    final ext = _fileExtension.toLowerCase();
    return ['md', 'markdown', 'mdown', 'mkd'].contains(ext);
  }

  bool get _isEditable {
    if (_isImage) return false;
    return _decodedContent != null;
  }

  String get _fileExtension {
    final lower = widget.name.toLowerCase();
    if (lower == 'dockerfile') return 'dockerfile';
    if (lower == 'makefile') return 'makefile';
    if (!widget.name.contains('.')) return '';
    return widget.name.split('.').last;
  }

  Future<void> _onWillPop() async {
    if (!_hasChanges) {
      Navigator.of(context).pop();
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.unsavedChanges),
        content: Text(l10n.unsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.discard),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              _saveFile();
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (result == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final hasContent = _decodedContent != null;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onWillPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          actions: [
            if (_isEditing && _hasChanges)
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: l10n.save,
                onPressed: _saveFile,
              ),
            if (_isEditable)
              IconButton(
                icon: Icon(_isEditing ? Icons.preview : Icons.edit),
                tooltip: _isEditing ? l10n.preview : l10n.edit,
                onPressed: _toggleEditMode,
              ),
            if (hasContent)
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: l10n.copyCode,
                onPressed: () => _copyToClipboard(context),
              ),
            if (widget.downloadUrl != null)
              IconButton(
                icon: const Icon(Icons.download),
                tooltip: l10n.downloadFile,
                onPressed: () => _downloadFile(context),
              ),
            if (hasContent)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                tooltip: l10n.more,
                onSelected: (value) {
                  switch (value) {
                    case 'history':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FileHistoryPage(
                            owner: widget.owner,
                            repo: widget.repo,
                            path: widget.path,
                            ref: widget.ref,
                          ),
                        ),
                      );
                    case 'compare':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FileComparePage(
                            owner: widget.owner,
                            repo: widget.repo,
                            path: widget.path,
                          ),
                        ),
                      );
                    case 'blame':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FileBlamePage(
                            owner: widget.owner,
                            repo: widget.repo,
                            path: widget.path,
                            ref: widget.ref,
                          ),
                        ),
                      );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'history',
                    child: ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(l10n.commitHistory),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'compare',
                    child: ListTile(
                      leading: const Icon(Icons.compare_arrows),
                      title: Text(l10n.compareVersions),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'blame',
                    child: ListTile(
                      leading: const Icon(Icons.face),
                      title: Text(l10n.blame),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildError(theme, l10n)
                : _buildContent(theme),
      ),
    );
  }

  void _toggleEditMode() {
    final newEditing = !_isEditing;
    if (newEditing) {
      _editController?.dispose();
      _editController = CodeController(
        text: _decodedContent ?? '',
        language: _getHighlightLanguage(_fileExtension),
      );
      _editController!.addListener(_onTextChanged);
    } else {
      _editController?.removeListener(_onTextChanged);
      _editController?.dispose();
      _editController = null;
    }
    setState(() {
      _isEditing = newEditing;
      _hasChanges = false;
    });
  }

  Future<void> _saveFile() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_hasChanges || _originalContent == null || _editController == null) return;

    final content = _editController!.text;
    final sha = _rawResponse?.sha;

    if (sha == null) {
      _showError(l10n.cannotGetFileSha);
      return;
    }

    final message = await _showCommitMessageDialog();
    if (message == null || message.isEmpty) return;
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await Injection.repoNotifier.updateFile(
      widget.owner,
      widget.repo,
      widget.path,
      base64Encode(utf8.encode(content)),
      message,
      branch: widget.ref,
      sha: sha,
    );

    if (!mounted) return;
    Navigator.of(context).pop(); // dismiss loading

    switch (result) {
      case Left<Failure, FileResponse>(:final value):
        _showError('${l10n.failedToSaveFile}: ${value.message}');
      case Right<Failure, FileResponse>():
        setState(() {
          _decodedContent = content;
          _originalContent = content;
          _hasChanges = false;
          _isEditing = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.fileSaved)),
          );
        }
    }
  }

  Future<String?> _showCommitMessageDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: l10n.commitUpdateFile(widget.name));
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.commitMessage),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.message,
            hintText: l10n.commitMessageHint,
          ),
          autofocus: true,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(l10n.commit),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  Widget _buildError(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(l10n.failedToLoadFile, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(_error!, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              setState(() { _loading = true; _error = null; });
              _loadFile();
            },
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
          if (widget.htmlUrl != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _launchUrl(widget.htmlUrl!),
              icon: const Icon(Icons.open_in_new),
              label: Text(l10n.openInBrowser),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    if (_isImage) {
      if (widget.downloadUrl != null) {
        return Center(
          child: Image.network(
            widget.downloadUrl!,
            errorBuilder: (context, error, stackTrace) => _buildFallback(theme, l10n),
          ),
        );
      }
      return _buildFallback(theme, l10n);
    }

    if (_isMarkdown && _decodedContent != null && !_isEditing) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MarkdownBody(data: _decodedContent!),
      );
    }

    if (_decodedContent != null) {
      if (_isEditing) {
        return _buildEditor(theme);
      }
      return _buildSelectableCode(theme);
    }

    return _buildFallback(theme, l10n);
  }

  Widget _buildEditor(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final codeTheme = isDark ? vs2015Theme : githubTheme;

    if (_editController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    try {
      return CodeTheme(
        data: CodeThemeData(styles: codeTheme),
        child: CodeField(
          controller: _editController!,
          expands: true,
          gutterStyle: GutterStyle.none,
          textStyle: const TextStyle(
            fontSize: 13,
            height: 1.4,
            fontFamily: 'monospace',
          ),
        ),
      );
    } catch (e) {
      return TextField(
        controller: _editController!,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(12),
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 13,
          height: 1.4,
          fontFamily: 'monospace',
          color: isDark ? const Color(0xFFD4D4D4) : const Color(0xFF24292E),
        ),
      );
    }
  }

  Widget _buildSelectableCode(ThemeData theme) {
    final lang = _languageForHighlight(_fileExtension);
    final isDark = theme.brightness == Brightness.dark;
    final codeTheme = isDark ? vs2015Theme : githubTheme;
    final content = _decodedContent!.replaceAll(RegExp(r'\n$'), '');
    final lines = content.split('\n');
    final lineCount = lines.length;
    final lineNumberWidth = (lineCount.toString().length * 10.0) + 16;

    Widget codeWidget;
    try {
      codeWidget = HighlightView(
        content,
        language: lang,
        theme: codeTheme,
        padding: const EdgeInsets.all(12),
        textStyle: const TextStyle(
          fontSize: 13,
          height: 1.4,
          fontFamily: 'monospace',
        ),
      );
    } catch (e) {
      codeWidget = Padding(
        padding: const EdgeInsets.all(12),
        child: SelectableText(
          content,
          style: TextStyle(
            fontSize: 13,
            height: 1.4,
            fontFamily: 'monospace',
            color: isDark ? const Color(0xFFD4D4D4) : const Color(0xFF24292E),
          ),
        ),
      );
    }

    return Container(
      color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            primary: false,
            child: SingleChildScrollView(
              primary: false,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Line numbers
                      Container(
                        width: lineNumberWidth,
                        color: isDark
                            ? const Color(0xFF252526)
                            : const Color(0xFFEEEEEE),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(
                            lineCount,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  fontFamily: 'monospace',
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Code with syntax highlighting
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: (constraints.maxWidth - lineNumberWidth)
                              .clamp(0, double.infinity),
                        ),
                        child: codeWidget,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFallback(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insert_drive_file, size: 64,
              color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(widget.name, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            _rawResponse?.size != null
                ? _formatSize(_rawResponse!.size!)
                : l10n.filePreviewNotAvailable,
            style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant),
          ),
          if (widget.htmlUrl != null) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _launchUrl(widget.htmlUrl!),
              icon: const Icon(Icons.open_in_new),
              label: Text(l10n.openInBrowser),
            ),
          ],
          if (widget.downloadUrl != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _launchUrl(widget.downloadUrl!),
              icon: const Icon(Icons.download),
              label: Text(l10n.download),
            ),
          ],
        ],
      ),
    );
  }

  String _languageForHighlight(String ext) {
    return switch (ext.toLowerCase()) {
      'dart' => 'dart',
      'js' => 'javascript',
      'ts' || 'tsx' => 'typescript',
      'py' => 'python',
      'rb' => 'ruby',
      'go' => 'go',
      'rs' => 'rust',
      'java' => 'java',
      'kt' => 'kotlin',
      'c' => 'cpp',
      'cpp' || 'cc' || 'cxx' => 'cpp',
      'h' => 'cpp',
      'cs' => 'cs',
      'swift' => 'swift',
      'scala' => 'scala',
      'sh' || 'bash' => 'bash',
      'yaml' || 'yml' => 'yaml',
      'json' => 'json',
      'xml' => 'xml',
      'html' || 'htm' => 'xml',
      'css' => 'css',
      'sql' => 'sql',
      'md' || 'markdown' => 'markdown',
      'toml' => 'ini',
      'ini' || 'cfg' || 'env' => 'ini',
      'dockerfile' => 'dockerfile',
      'makefile' => 'makefile',
      'lua' => 'lua',
      'perl' => 'perl',
      'php' => 'php',
      'r' => 'r',
      _ => 'plaintext',
    };
  }

  Mode? _getHighlightLanguage(String ext) {
    final langName = _languageForHighlight(ext);
    if (langName == 'plaintext') return null;
    return allLanguages[langName];
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (_decodedContent == null) return;
    await Clipboard.setData(ClipboardData(text: _decodedContent!));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.copied)),
      );
    }
  }

  Future<void> _downloadFile(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.downloadUrl == null) return;
    final uri = Uri.tryParse(widget.downloadUrl!);
    if (uri != null) {
      final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToOpenDownloadUrl)),
        );
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}