import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../l10n/app_localizations.dart';

class WikiEditPage extends StatefulWidget {
  final String owner;
  final String repo;
  final String? pageName;
  final String? initialContent;

  const WikiEditPage({
    super.key,
    required this.owner,
    required this.repo,
    this.pageName,
    this.initialContent,
  });

  @override
  State<WikiEditPage> createState() => _WikiEditPageState();
}

class _WikiEditPageState extends State<WikiEditPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _messageController;
  bool _isSaving = false;
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.pageName ?? '');
    _contentController = TextEditingController(text: widget.initialContent ?? '');
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.titleRequired)),
      );
      return;
    }

    setState(() => _isSaving = true);

    final Either<dynamic, dynamic> result;
    if (widget.pageName != null) {
      result = await Injection.repoNotifier.editWikiPage(
        widget.owner,
        widget.repo,
        title,
        content,
        message: _messageController.text.trim().isNotEmpty
            ? _messageController.text.trim()
            : null,
      );
    } else {
      result = await Injection.repoNotifier.createWikiPage(
        widget.owner,
        widget.repo,
        title,
        content,
        message: _messageController.text.trim().isNotEmpty
            ? _messageController.text.trim()
            : null,
      );
    }

    if (mounted) {
      setState(() => _isSaving = false);
      switch (result) {
        case Left(:final value):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.error}: ${value.message}')),
          );
        case Right():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.pageName != null ? l10n.saved : l10n.created)),
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
        title: Text(widget.pageName != null ? l10n.editWikiPage : l10n.newWikiPage),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : () => setState(() => _showPreview = !_showPreview),
            child: Text(_showPreview ? l10n.edit : l10n.preview),
          ),
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _save,
          ),
        ],
      ),
      body: _showPreview ? _buildPreview() : _buildForm(l10n),
    );
  }

  Widget _buildPreview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(UIConstants.md),
      child: MarkdownBody(
        data: _contentController.text,
        selectable: true,
      ),
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(UIConstants.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: l10n.wikiPageTitle,
              hintText: l10n.wikiPageTitleHint,
              border: const OutlineInputBorder(),
            ),
            enabled: widget.pageName == null,
          ),
          const SizedBox(height: UIConstants.md),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(
              labelText: l10n.wikiPageContent,
              hintText: l10n.wikiPageContentHint,
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: null,
            minLines: 10,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: UIConstants.md),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(
              labelText: l10n.commitMessage,
              hintText: l10n.commitMessageHint,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
