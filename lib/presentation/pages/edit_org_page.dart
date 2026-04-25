import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../data/models/generated/generated_models.dart';
import '../../l10n/app_localizations.dart';
import '../state/organization_notifier.dart';

class EditOrgPage extends StatefulWidget {
  final Organization org;

  const EditOrgPage({
    super.key,
    required this.org,
  });

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
    _fullNameController = TextEditingController(text: widget.org.full_name ?? '');
    _descriptionController = TextEditingController(text: widget.org.description ?? '');
    _locationController = TextEditingController(text: widget.org.location ?? '');
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

    await Injection.organizationNotifier.editOrg(widget.org.username ?? '', body);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      final state = Injection.organizationNotifier.state;
      if (state is OrgLoaded) {
        Navigator.pop(context, true);
      } else if (state is OrgError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editOrganization),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text(l10n.save),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _fullNameController,
            decoration: InputDecoration(
              labelText: l10n.fullName,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: l10n.description,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: l10n.location,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _websiteController,
            decoration: InputDecoration(
              labelText: l10n.website,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: l10n.email,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _visibility,
            decoration: InputDecoration(
              labelText: l10n.visibility,
              border: const OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'public', child: Text('Public')),
              DropdownMenuItem(value: 'limited', child: Text('Limited')),
              DropdownMenuItem(value: 'private', child: Text('Private')),
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
