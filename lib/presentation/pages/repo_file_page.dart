import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/repo_usecases.dart';

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
  ContentsResponse? _rawResponse;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFile();
    });
  }

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
              final cleaned = item.content!.replaceAll(RegExp(r'\s'), '');
              decoded = utf8.decode(base64Decode(cleaned));
            } catch (_) {
              decoded = null;
            }
          }
          setState(() {
            _rawResponse = item;
            _decodedContent = decoded;
            _loading = false;
          });
        } else {
          setState(() {
            _loading = false;
            _error = 'File not found';
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

  String get _fileExtension {
    if (!widget.name.contains('.')) return '';
    return widget.name.split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError(theme)
              : _buildContent(theme),
    );
  }

  Widget _buildError(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text('Failed to load file', style: theme.textTheme.titleMedium),
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
            label: const Text('Retry'),
          ),
          if (widget.htmlUrl != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _launchUrl(widget.htmlUrl!),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open in browser'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_isImage) {
      if (widget.downloadUrl != null) {
        return Center(
          child: Image.network(
            widget.downloadUrl!,
            errorBuilder: (context, error, stackTrace) => _buildFallback(theme),
          ),
        );
      }
      return _buildFallback(theme);
    }

    if (_isMarkdown && _decodedContent != null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MarkdownBody(data: _decodedContent!),
      );
    }

    if (_decodedContent != null) {
      final lang = _languageForHighlight(_fileExtension);
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: HighlightView(
            _decodedContent!,
            language: lang,
            theme: githubTheme,
          ),
        ),
      );
    }

    return _buildFallback(theme);
  }

  Widget _buildFallback(ThemeData theme) {
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
                : 'File preview not available',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant),
          ),
          if (widget.htmlUrl != null) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _launchUrl(widget.htmlUrl!),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open in browser'),
            ),
          ],
          if (widget.downloadUrl != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _launchUrl(widget.downloadUrl!),
              icon: const Icon(Icons.download),
              label: const Text('Download'),
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
      'zig' => 'zig',
      _ => 'plaintext',
    };
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}