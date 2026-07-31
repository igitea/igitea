import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/storage/auth_method_storage.dart';
import '../../core/storage/auth_storage.dart';
import '../../domain/entities/auth_state.dart';
import '../../l10n/app_localizations.dart';

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

  final _oauthClientIdController = TextEditingController();
  final _oauthClientSecretController = TextEditingController();
  final _oauthRedirectUriController = TextEditingController(
    text: 'igitea://oauth/callback',
  );
  final _oauthCodeController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureToken = true;
  bool _restoringCredentials = true;
  bool _oauthCodeExchanging = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        } else if (saved.method == AuthMethod.oauth2) {
          _tabController.index = 2;
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
    _oauthClientIdController.dispose();
    _oauthClientSecretController.dispose();
    _oauthRedirectUriController.dispose();
    _oauthCodeController.dispose();
    super.dispose();
  }

  String? _validateUrl(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.pleaseEnterServerUrl;
    }
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return l10n.pleaseEnterValidUrl;
    }
    if (uri.scheme != 'https') {
      if (kDebugMode && _isLocalOrPrivateHost(uri.host)) {
        return null;
      }
      return l10n.requireHttps;
    }
    return null;
  }

  bool _isLocalOrPrivateHost(String host) {
    return host == 'localhost' ||
           host == '127.0.0.1' ||
           host.startsWith('192.168.') ||
           host.startsWith('10.') ||
           host.startsWith('172.16.') ||
           host.startsWith('172.17.') ||
           host.startsWith('172.18.') ||
           host.startsWith('172.19.') ||
           host.startsWith('172.20.') ||
           host.startsWith('172.21.') ||
           host.startsWith('172.22.') ||
           host.startsWith('172.23.') ||
           host.startsWith('172.24.') ||
           host.startsWith('172.25.') ||
           host.startsWith('172.26.') ||
           host.startsWith('172.27.') ||
           host.startsWith('172.28.') ||
           host.startsWith('172.29.') ||
           host.startsWith('172.30.') ||
           host.startsWith('172.31.');
  }

  Future<void> _loginWithBasicAuth() async {
    if (!_basicFormKey.currentState!.validate()) return;

    final baseUrl = _baseUrlController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    Injection.updateAuth(
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

    Injection.updateAuth(baseUrl: baseUrl, token: token);
    await Injection.authNotifier.loginWithToken(baseUrl, token);
  }

  Future<void> _openOAuth2Authorization() async {
    final baseUrl = _baseUrlController.text.trim();
    final clientId = _oauthClientIdController.text.trim();
    final redirectUri = _oauthRedirectUriController.text.trim();

    if (baseUrl.isEmpty || clientId.isEmpty || redirectUri.isEmpty) return;

    Injection.updateAuth(baseUrl: baseUrl);
    await Injection.authNotifier.openOAuth2Authorization(
      baseUrl: baseUrl,
      clientId: clientId,
      redirectUri: redirectUri,
    );
  }

  Future<void> _exchangeOAuth2Code() async {
    final l10n = AppLocalizations.of(context)!;
    final baseUrl = _baseUrlController.text.trim();
    final clientId = _oauthClientIdController.text.trim();
    final clientSecret = _oauthClientSecretController.text.trim();
    final code = _oauthCodeController.text.trim();
    final redirectUri = _oauthRedirectUriController.text.trim();

    if (baseUrl.isEmpty || clientId.isEmpty || code.isEmpty) return;

    setState(() => _oauthCodeExchanging = true);

    try {
      final result = await Injection.authNotifier.exchangeOAuth2Code(
        baseUrl: baseUrl,
        clientId: clientId,
        clientSecret: clientSecret,
        code: code,
        redirectUri: redirectUri,
      );

      final accessToken = result['access_token'] as String?;
      final refreshToken = result['refresh_token'] as String?;

      if (accessToken == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.error}: ${l10n.failedToGetAccessToken}')),
          );
        }
        setState(() => _oauthCodeExchanging = false);
        return;
      }

      Injection.initialize(baseUrl: baseUrl, token: accessToken);
      await Injection.authNotifier.loginWithOAuth2(
        baseUrl: baseUrl,
        token: accessToken,
        refreshToken: refreshToken,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _oauthCodeExchanging = false);
      _oauthClientSecretController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UIConstants.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: ListenableBuilder(
                listenable: Injection.authNotifier,
                builder: (context, child) {
                  final state = Injection.authNotifier.state;

                  if (state is AuthLoading && _restoringCredentials) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: UIConstants.md),
                          Text(l10n.restoringSession),
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
                      Semantics(
                        label: l10n.appTitle,
                        child: Icon(
                          Icons.code,
                          size: 64,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: UIConstants.md),
                      Text(
                        l10n.appTitle,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: UIConstants.sm),
                      Text(
                        l10n.connectToGitea,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: UIConstants.xl),
                      if (errorMessage != null)
                        Card(
                          color: theme.colorScheme.errorContainer,
                          margin: const EdgeInsets.only(bottom: UIConstants.md),
                          child: Padding(
                            padding: const EdgeInsets.all(UIConstants.sm),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                                const SizedBox(width: UIConstants.sm),
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
                        tabs: [
                          Tab(text: l10n.usernamePassword),
                          Tab(text: l10n.token),
                          Tab(text: l10n.oauth2),
                        ],
                      ),
                      const SizedBox(height: UIConstants.md),
                      SizedBox(
                        height: 420,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildBasicAuthForm(theme, isLoading, l10n),
                            _buildTokenForm(theme, isLoading, l10n),
                            _buildOAuth2Form(theme, isLoading, l10n),
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

  Widget _buildBasicAuthForm(ThemeData theme, bool isLoading, AppLocalizations l10n) {
    return Form(
      key: _basicFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _baseUrlController,
            decoration: InputDecoration(
              labelText: l10n.serverUrl,
              hintText: 'https://gitea.example.com',
              prefixIcon: const Icon(Icons.dns_outlined),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: (value) => _validateUrl(value, l10n),
            enabled: !isLoading,
            autofillHints: const [AutofillHints.url],
          ),
          const SizedBox(height: UIConstants.lg),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: l10n.username,
              hintText: l10n.enterUsername,
              prefixIcon: const Icon(Icons.person_outlined),
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnterUsername;
              }
              return null;
            },
            enabled: !isLoading,
            autofillHints: const [AutofillHints.username],
          ),
          const SizedBox(height: UIConstants.lg),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: l10n.password,
              hintText: l10n.enterPassword,
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
                return l10n.pleaseEnterPassword;
              }
              return null;
            },
            autofillHints: const [AutofillHints.password],
            enabled: !isLoading,
          ),
          const SizedBox(height: UIConstants.lg),
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
                  : Text(l10n.signIn),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenForm(ThemeData theme, bool isLoading, AppLocalizations l10n) {
    return Form(
      key: _tokenFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _baseUrlController,
            decoration: InputDecoration(
              labelText: l10n.serverUrl,
              hintText: 'https://gitea.example.com',
              prefixIcon: const Icon(Icons.dns_outlined),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: (value) => _validateUrl(value, l10n),
            enabled: !isLoading,
          ),
          const SizedBox(height: UIConstants.lg),
          TextFormField(
            controller: _tokenController,
            decoration: InputDecoration(
              labelText: l10n.token,
              hintText: l10n.pasteAccessToken,
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
                return l10n.pleaseEnterAccessToken;
              }
              return null;
            },
            enabled: !isLoading,
          ),
          const SizedBox(height: UIConstants.lg),
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
                  : Text(l10n.signInWithToken),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOAuth2Form(ThemeData theme, bool isLoading, AppLocalizations l10n) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(l10n.oauth2Description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.lg),
          TextFormField(
            controller: _baseUrlController,
            decoration: InputDecoration(
              labelText: l10n.serverUrl,
              hintText: 'https://gitea.example.com',
              prefixIcon: const Icon(Icons.dns_outlined),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: (value) => _validateUrl(value, l10n),
            enabled: !isLoading,
          ),
          const SizedBox(height: UIConstants.md),
          TextFormField(
            controller: _oauthClientIdController,
            decoration: InputDecoration(
              labelText: l10n.oauth2ClientId,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.requiredField;
              }
              return null;
            },
            enabled: !isLoading,
          ),
          const SizedBox(height: UIConstants.md),
          TextFormField(
            controller: _oauthClientSecretController,
            decoration: InputDecoration(
              labelText: l10n.oauth2ClientSecret,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.requiredField;
              }
              return null;
            },
            enabled: !isLoading,
          ),
          const SizedBox(height: UIConstants.sm),
          TextFormField(
            controller: _oauthRedirectUriController,
            decoration: InputDecoration(
              labelText: l10n.oauth2RedirectUri,
              hintText: l10n.oauth2RedirectUriHint,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.url,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.requiredField;
              }
              return null;
            },
            enabled: !isLoading,
          ),
          const SizedBox(height: UIConstants.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : _openOAuth2Authorization,
              icon: const Icon(Icons.open_in_new),
              label: Text(l10n.oauth2Authorize),
            ),
          ),
          const SizedBox(height: UIConstants.lg),
          TextFormField(
            controller: _oauthCodeController,
            decoration: InputDecoration(
              labelText: l10n.oauth2AuthorizationCode,
              hintText: l10n.oauth2AuthorizationCodeHint,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.requiredField;
              }
              return null;
            },
            enabled: !isLoading && !_oauthCodeExchanging,
          ),
          const SizedBox(height: UIConstants.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading || _oauthCodeExchanging ? null : _exchangeOAuth2Code,
              child: _oauthCodeExchanging
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.loginWithOAuth2),
            ),
          ),
        ],
      ),
    );
  }
}
