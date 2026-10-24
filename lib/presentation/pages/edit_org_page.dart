import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/organization_notifier.dart';
import '../widgets/forui/app_page.dart';

class EditOrgPage extends StatefulWidget {
  final Organization org;

  const EditOrgPage({super.key, required this.org});

  @override
  State<EditOrgPage> createState() => _EditOrgPageState();
}

class _EditOrgPageState extends State<EditOrgPage> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _websiteController;
  late final TextEditingController _emailController;
  String? _visibility;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.org.full_name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.org.description ?? '',
    );
    _locationController = TextEditingController(
      text: widget.org.location ?? '',
    );
    _websiteController = TextEditingController(text: widget.org.website ?? '');
    _emailController = TextEditingController(text: widget.org.email ?? '');
    _visibility = widget.org.visibility ?? 'public';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _isLoading = true;
    });

    final body = <String, dynamic>{};
    if (_fullNameController.text.isNotEmpty) {
      body['full_name'] = _fullNameController.text;
    }
    if (_descriptionController.text.isNotEmpty) {
      body['description'] = _descriptionController.text;
    }
    if (_locationController.text.isNotEmpty) {
      body['location'] = _locationController.text;
    }
    if (_websiteController.text.isNotEmpty) {
      body['website'] = _websiteController.text;
    }
    if (_emailController.text.isNotEmpty) {
      body['email'] = _emailController.text;
    }
    body['visibility'] = _visibility;

    await Injection.organizationNotifier.editOrg(
      widget.org.username ?? '',
      body,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      final state = Injection.organizationNotifier.state;
      if (state is OrgLoaded) {
        Navigator.pop(context, true);
      } else if (state is OrgError) {
        showFToast(
          context: context,
          variant: .destructive,
          title: Text(state.message),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPage(
      maxContentWidth: 760,
      title: l10n.editOrganization,
      actions: [
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8),
            child: FCircularProgress(size: .sm),
          )
        else
          FHeaderAction(
            icon: const Icon(FIcons.save),
            semanticsLabel: l10n.save,
            onPress: _save,
          ),
      ],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FTextFormField(
            control: FTextFieldControl.managed(controller: _fullNameController),
            label: Text(l10n.fullName),
          ),
          const SizedBox(height: 16),
          FTextField(
            control: FTextFieldControl.managed(
              controller: _descriptionController,
            ),
            label: Text(l10n.description),
            maxLines: 3,
            minLines: 3,
          ),
          const SizedBox(height: 16),
          FTextFormField(
            control: FTextFieldControl.managed(controller: _locationController),
            label: Text(l10n.location),
          ),
          const SizedBox(height: 16),
          FTextFormField(
            control: FTextFieldControl.managed(controller: _websiteController),
            label: Text(l10n.website),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),
          FTextFormField(
            control: FTextFieldControl.managed(controller: _emailController),
            label: Text(l10n.email),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _visibility,
            decoration: InputDecoration(
              labelText: l10n.visibility,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(value: 'public', child: Text(l10n.public)),
              DropdownMenuItem(value: 'limited', child: Text(l10n.limited)),
              DropdownMenuItem(value: 'private', child: Text(l10n.private)),
            ],
            onChanged: (value) {
              setState(() {
                _visibility = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
