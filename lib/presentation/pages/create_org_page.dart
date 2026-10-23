import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../state/organization_notifier.dart';
import '../widgets/forui/app_page.dart';

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
      title: l10n.createOrganization,
      actions: [
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8),
            child: FCircularProgress(size: .sm),
          )
        else
          FHeaderAction(
            icon: const Icon(FIcons.check),
            semanticsLabel: l10n.create,
            onPress: _create,
          ),
      ],
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FTextFormField(
              control: FTextFieldControl.managed(
                controller: _usernameController,
              ),
              label: Text(l10n.username),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.usernameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            FTextFormField(
              control: FTextFieldControl.managed(
                controller: _fullNameController,
              ),
              label: Text(l10n.fullName),
              textInputAction: TextInputAction.next,
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
              control: FTextFieldControl.managed(
                controller: _locationController,
              ),
              label: Text(l10n.location),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            FTextFormField(
              control: FTextFieldControl.managed(
                controller: _websiteController,
              ),
              label: Text(l10n.website),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            FTextFormField(
              control: FTextFieldControl.managed(controller: _emailController),
              label: Text(l10n.email),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
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
