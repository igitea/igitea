import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:forui/forui.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/all.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/repo_usecases.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_palette.dart';
import '../widgets/app_markdown.dart';
import '../widgets/app_surface.dart';
import '../widgets/forui/app_page.dart';
import '../widgets/forui/app_state_views.dart';
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
  /// Files larger than 1MB are not rendered inline — syntax highlighting a
  /// multi-MB document in one TextSpan tree freezes the UI thread.
  static const _maxPreviewBytes = 1 << 20;

  /// Markdown documents larger than 512KB are not rendered inline.
  static const _maxMarkdownBytes = 512 << 10;

  /// Code previews are chunked into blocks of this many lines so
  /// ListView.builder can build them lazily.
  static const _linesPerChunk = 500;

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
    final result = await showFDialog<bool>(
      context: context,
      builder: (context, style, animation) => FDialog(
        title: Text(l10n.unsavedChanges),
        body: Text(l10n.unsavedChangesMessage),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(context).pop(true),
            child: Text(l10n.discard),
          ),
          FButton(
            onPress: () {
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
    final l10n = AppLocalizations.of(context)!;
    final hasContent = _decodedContent != null;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onWillPop();
      },
      child: AppPage(
        title: widget.name,
        subtitle: '${widget.owner}/${widget.repo} · ${widget.path}',
        actions: [
          if (_isEditing && _hasChanges)
            FHeaderAction(
              icon: const Icon(FIcons.save),
              semanticsLabel: l10n.save,
              onPress: _saveFile,
            ),
          if (_isEditable)
            FHeaderAction(
              icon: Icon(_isEditing ? FIcons.eye : FIcons.penLine),
              semanticsLabel: _isEditing ? l10n.preview : l10n.edit,
              onPress: _toggleEditMode,
            ),
          if (hasContent)
            FHeaderAction(
              icon: const Icon(FIcons.copy),
              semanticsLabel: l10n.copyCode,
              onPress: () => _copyToClipboard(context),
            ),
          if (widget.downloadUrl != null)
            FHeaderAction(
              icon: const Icon(FIcons.download),
              semanticsLabel: l10n.downloadFile,
              onPress: () => _downloadFile(context),
            ),
          if (hasContent)
            FPopoverMenu(
              menuAnchor: Alignment.topRight,
              childAnchor: Alignment.bottomRight,
              menu: [
                FItemGroup(
                  children: [
                    FItem(
                      prefix: const Icon(FIcons.history),
                      title: Text(l10n.commitHistory),
                      onPress: _openHistory,
                    ),
                    FItem(
                      prefix: const Icon(FIcons.gitCompareArrows),
                      title: Text(l10n.compareVersions),
                      onPress: _openCompare,
                    ),
                    FItem(
                      prefix: const Icon(FIcons.smile),
                      title: Text(l10n.blame),
                      onPress: _openBlame,
                    ),
                  ],
                ),
              ],
              builder: (context, controller, child) => FHeaderAction(
                icon: const Icon(FIcons.ellipsisVertical),
                semanticsLabel: l10n.more,
                onPress: () => controller.toggle(),
              ),
            ),
        ],
        child: _loading
            ? const AppLoading()
            : _error != null
            ? _buildError(l10n)
            : _buildContent(),
      ),
    );
  }

  void _openHistory() {
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
  }

  void _openCompare() {
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
  }

  void _openBlame() {
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

  void _toggleEditMode() {
    final newEditing = !_isEditing;
    if (newEditing) {
      final content = _decodedContent ?? '';
      if (content.length > _maxPreviewBytes) {
        _showError(
          AppLocalizations.of(
            context,
          )!.fileTooLargeParams(_formatSize(content.length)),
        );
        return;
      }
      _editController?.dispose();
      _editController = CodeController(
        text: content,
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
    if (!_hasChanges || _originalContent == null || _editController == null) {
      return;
    }

    final content = _editController!.text;
    final sha = _rawResponse?.sha;

    if (sha == null) {
      _showError(l10n.cannotGetFileSha);
      return;
    }

    final message = await _showCommitMessageDialog();
    if (message == null || message.isEmpty) return;
    if (!mounted) return;

    showFDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context, style, animation) => FDialog(
        body: const Center(child: FCircularProgress()),
        actions: const [],
      ),
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
          showFToast(context: context, title: Text(l10n.fileSaved));
        }
    }
  }

  Future<String?> _showCommitMessageDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(
      text: l10n.commitUpdateFile(widget.name),
    );
    final result = await showFDialog<String>(
      context: context,
      builder: (context, style, animation) => FDialog(
        title: Text(l10n.commitMessage),
        body: FTextField(
          control: FTextFieldControl.managed(controller: controller),
          label: Text(l10n.message),
          hint: l10n.commitMessageHint,
          autofocus: true,
          minLines: 3,
          maxLines: 3,
        ),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FButton(
            onPress: () => Navigator.of(context).pop(controller.text),
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
    final l10n = AppLocalizations.of(context)!;
    showFDialog<void>(
      context: context,
      builder: (context, style, animation) => FDialog(
        title: Text(l10n.error),
        body: Text(message),
        actions: [
          FButton(
            variant: .outline,
            onPress: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Widget _buildError(AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppError(
          title: l10n.failedToLoadFile,
          message: _error!,
          onRetry: () {
            setState(() {
              _loading = true;
              _error = null;
            });
            _loadFile();
          },
        ),
        if (widget.htmlUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FButton(
              variant: .outline,
              prefix: const Icon(FIcons.externalLink, size: 16),
              onPress: () => _launchUrl(widget.htmlUrl!),
              child: Text(l10n.openInBrowser),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    final l10n = AppLocalizations.of(context)!;
    if (_isImage) {
      if (widget.downloadUrl != null) {
        final dpr = MediaQuery.devicePixelRatioOf(context);
        return Center(
          child: Image.network(
            widget.downloadUrl!,
            cacheWidth: (MediaQuery.sizeOf(context).width * dpr).round(),
            cacheHeight: (MediaQuery.sizeOf(context).height * dpr).round(),
            semanticLabel: 'Image preview',
            errorBuilder: (context, error, stackTrace) => _buildFallback(l10n),
          ),
        );
      }
      return _buildFallback(l10n);
    }

    if (_isMarkdown && _decodedContent != null && !_isEditing) {
      if (_decodedContent!.length > _maxMarkdownBytes) {
        return _buildTooLarge(l10n, isMarkdown: true);
      }
      return SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: AppSurface(
                padding: const EdgeInsets.fromLTRB(36, 28, 36, 36),
                child: AppMarkdown(data: _decodedContent!),
              ),
            ),
          ),
        ),
      );
    }

    if (_decodedContent != null) {
      if (_decodedContent!.length > _maxPreviewBytes) {
        return _buildTooLarge(l10n, isMarkdown: false);
      }
      if (_isEditing) {
        return _buildEditor(Theme.of(context));
      }
      return _buildSelectableCode(Theme.of(context));
    }

    return _buildFallback(l10n);
  }

  Widget _buildTooLarge(AppLocalizations l10n, {required bool isMarkdown}) {
    final size = _decodedContent!.length;
    return AppEmpty(
      icon: FIcons.fileText,
      title: widget.name,
      subtitle: isMarkdown
          ? l10n.documentTooLarge
          : l10n.fileTooLargeParams(_formatSize(size)),
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.htmlUrl != null)
            FButton(
              prefix: const Icon(FIcons.externalLink, size: 16),
              onPress: () => _launchUrl(widget.htmlUrl!),
              child: Text(l10n.openInBrowser),
            ),
          if (widget.downloadUrl != null) ...[
            const SizedBox(height: 8),
            FButton(
              variant: .outline,
              prefix: const Icon(FIcons.download, size: 16),
              onPress: () => _launchUrl(widget.downloadUrl!),
              child: Text(l10n.download),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEditor(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final codeTheme = isDark ? vs2015Theme : githubTheme;

    if (_editController == null) {
      return const Center(child: FCircularProgress());
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
    final palette = context.palette;
    final lang = _languageForHighlight(_fileExtension);
    final isDark = theme.brightness == Brightness.dark;
    final codeTheme = isDark ? vs2015Theme : githubTheme;
    final content = _decodedContent!.replaceAll(RegExp(r'\n$'), '');
    final lines = content.split('\n');
    final lineCount = lines.length;
    final lineNumberWidth = (lineCount.toString().length * 10.0) + 16;
    final chunkCount = (lineCount / _linesPerChunk).ceil();

    // Render the file in chunks of [_linesPerChunk] lines so ListView.builder
    // only builds what's on screen — a single HighlightView over a huge file
    // builds one giant TextSpan tree and freezes the UI.
    return Container(
      color: palette.surface,
      child: ListView.builder(
        itemCount: chunkCount,
        itemBuilder: (context, chunkIndex) {
          final start = chunkIndex * _linesPerChunk;
          final end = (start + _linesPerChunk) > lineCount
              ? lineCount
              : start + _linesPerChunk;
          final chunkLines = lines.sublist(start, end);
          final chunkText = chunkLines.join('\n');

          Widget codeWidget;
          try {
            codeWidget = HighlightView(
              chunkText,
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
                chunkText,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  fontFamily: 'monospace',
                  color: isDark
                      ? const Color(0xFFD4D4D4)
                      : const Color(0xFF24292E),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            primary: false,
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line numbers
                Container(
                  width: lineNumberWidth,
                  color: palette.surfaceMuted,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      chunkLines.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${start + index + 1}',
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
                codeWidget,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFallback(AppLocalizations l10n) {
    return AppEmpty(
      icon: FIcons.file,
      title: widget.name,
      subtitle: _rawResponse?.size != null
          ? _formatSize(_rawResponse!.size!)
          : l10n.filePreviewNotAvailable,
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.htmlUrl != null)
            FButton(
              prefix: const Icon(FIcons.externalLink, size: 16),
              onPress: () => _launchUrl(widget.htmlUrl!),
              child: Text(l10n.openInBrowser),
            ),
          if (widget.downloadUrl != null) ...[
            const SizedBox(height: 8),
            FButton(
              variant: .outline,
              prefix: const Icon(FIcons.download, size: 16),
              onPress: () => _launchUrl(widget.downloadUrl!),
              child: Text(l10n.download),
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
      showFToast(context: context, title: Text(l10n.copied));
    }
  }

  Future<void> _downloadFile(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.downloadUrl == null) return;
    final uri = Uri.tryParse(widget.downloadUrl!);
    if (uri != null) {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!success && context.mounted) {
        showFToast(
          context: context,
          variant: .destructive,
          title: Text(l10n.failedToOpenDownloadUrl),
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
