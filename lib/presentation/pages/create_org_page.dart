import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../state/organization_notifier.dart';

class CreateOrgPage extends StatefulWidget {
  const CreateOrgPage({super.key});

  @override
  State<CreateOrgPage> createState() => _CreateOrgPageState();
}

class _CreateOrgPageState extends State<CreateOrgPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _websiteController = TextEditingController();
  final _emailController = TextEditingController();
  String _visibility = 'public';
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final body = <String, dynamic>{
      'username': _usernameController.text,
      'visibility': _visibility,
    };
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

    await Injection.organizationNotifier.createOrg(body);

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
        title: Text(l10n.createOrganization),
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
              onPressed: _create,
              child: Text(l10n.create),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: l10n.username,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.usernameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
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
                  _visibility = value ?? 'public';
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
