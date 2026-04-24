import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../core/storage/auth_method_storage.dart';
import '../../core/storage/auth_storage.dart';
import '../../domain/entities/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _basicFormKey = GlobalKey<FormState>();
  final _tokenFormKey = GlobalKey<FormState>();

  final _baseUrlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tokenController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureToken = true;
  bool _restoringCredentials = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final storage = AuthStorage();
    final saved = await storage.loadCredentials();
    if (saved != null && mounted) {
      setState(() {
        _baseUrlController.text = saved.baseUrl;
        if (saved.method == AuthMethod.basic) {
          _usernameController.text = saved.username ?? '';
          _passwordController.text = saved.password ?? '';
          _tabController.index = 0;
        } else {
          _tokenController.text = saved.token ?? '';
          _tabController.index = 1;
        }
      });
    }
    setState(() {
      _restoringCredentials = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _baseUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a server URL';
    }
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  Future<void> _loginWithBasicAuth() async {
    if (!_basicFormKey.currentState!.validate()) return;

    final baseUrl = _baseUrlController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    Injection.initialize(
      baseUrl: baseUrl,
      username: username,
      password: password,
    );
    await Injection.authNotifier.loginWithBasicAuth(
      baseUrl,
      username,
      password,
    );
  }

  Future<void> _loginWithToken() async {
    if (!_tokenFormKey.currentState!.validate()) return;

    final baseUrl = _baseUrlController.text.trim();
    final token = _tokenController.text.trim();

    Injection.initialize(baseUrl: baseUrl, token: token);
    await Injection.authNotifier.loginWithToken(baseUrl, token);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: ListenableBuilder(
                listenable: Injection.authNotifier,
                builder: (context, child) {
                  final state = Injection.authNotifier.state;

                  if (state is AuthLoading && _restoringCredentials) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Restoring session...'),
                        ],
                      ),
                    );
                  }

                  final isLoading = state is AuthLoading;
                  final errorMessage = state is AuthError
                      ? state.message
                      : null;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.code,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'iGitea',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Connect to your Gitea instance',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (errorMessage != null)
                        Card(
                          color: theme.colorScheme.errorContainer,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    errorMessage,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onErrorContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Username & Password'),
                          Tab(text: 'Access Token'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 340,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildBasicAuthForm(theme, isLoading),
                            _buildTokenForm(theme, isLoading),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicAuthForm(ThemeData theme, bool isLoading) {
    return Form(
      key: _basicFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _baseUrlController,
            decoration: const InputDecoration(
              labelText: 'Server URL',
              hintText: 'https://gitea.example.com',
              prefixIcon: Icon(Icons.dns_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: _validateUrl,
            enabled: !isLoading,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              hintText: 'Enter your username',
              prefixIcon: Icon(Icons.person_outlined),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
            enabled: !isLoading,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock_outlined),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _loginWithBasicAuth(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            enabled: !isLoading,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading ? null : _loginWithBasicAuth,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Sign In'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenForm(ThemeData theme, bool isLoading) {
    return Form(
      key: _tokenFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _baseUrlController,
            decoration: const InputDecoration(
              labelText: 'Server URL',
              hintText: 'https://gitea.example.com',
              prefixIcon: Icon(Icons.dns_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: _validateUrl,
            enabled: !isLoading,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tokenController,
            decoration: InputDecoration(
              labelText: 'Access Token',
              hintText: 'Paste your personal access token',
              prefixIcon: const Icon(Icons.key_outlined),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureToken ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureToken = !_obscureToken;
                  });
                },
              ),
            ),
            obscureText: _obscureToken,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _loginWithToken(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter an access token';
              }
              return null;
            },
            enabled: !isLoading,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading ? null : _loginWithToken,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Sign In with Token'),
            ),
          ),
        ],
      ),
    );
  }
}
