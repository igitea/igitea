import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:forui/forui.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/either.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/forui/app_page.dart';

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
    _contentController = TextEditingController(
      text: widget.initialContent ?? '',
    );
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
      showFToast(
        context: context,
        variant: .destructive,
        title: Text(l10n.titleRequired),
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
          showFToast(
            context: context,
            variant: .destructive,
            title: Text('${l10n.error}: ${value.message}'),
          );
        case Right():
          showFToast(
            context: context,
            title: Text(widget.pageName != null ? l10n.saved : l10n.created),
          );
          Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      title: widget.pageName != null ? l10n.editWikiPage : l10n.newWikiPage,
      actions: [
        FHeaderAction(
          icon: Icon(_showPreview ? FIcons.pencil : FIcons.eye),
          semanticsLabel: _showPreview ? l10n.edit : l10n.preview,
          onPress: _isSaving
              ? null
              : () => setState(() => _showPreview = !_showPreview),
        ),
        FHeaderAction(
          icon: _isSaving
              ? const FCircularProgress(size: .sm)
              : const Icon(FIcons.save),
          semanticsLabel: l10n.save,
          onPress: _isSaving ? null : _save,
        ),
      ],
      child: _showPreview ? _buildPreview() : _buildForm(l10n),
    );
  }

  Widget _buildPreview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(UIConstants.md),
      child: MarkdownBody(data: _contentController.text, selectable: true),
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(UIConstants.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FTextField(
            control: FTextFieldControl.managed(controller: _titleController),
            label: Text(l10n.wikiPageTitle),
            hint: l10n.wikiPageTitleHint,
            maxLength: 100,
            enabled: widget.pageName == null,
          ),
          const SizedBox(height: UIConstants.md),
          FTextField(
            control: FTextFieldControl.managed(controller: _contentController),
            label: Text(l10n.wikiPageContent),
            hint: l10n.wikiPageContentHint,
            maxLines: null,
            minLines: 10,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: UIConstants.md),
          FTextField(
            control: FTextFieldControl.managed(controller: _messageController),
            label: Text(l10n.commitMessage),
            hint: l10n.commitMessageHint,
          ),
        ],
      ),
    );
  }
}
