import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/di/injection.dart';
import '../../core/storage/auth_method_storage.dart';
import '../../core/storage/auth_storage.dart';
import '../../domain/entities/auth_state.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_palette.dart';
import '../widgets/app_surface.dart';
import '../widgets/forui/app_chrome.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  /// 0 = account, 1 = token, 2 = OAuth2.
  int _mode = 0;
  bool _restoringCredentials = true;
  bool _oauthCodeExchanging = false;

  @override
  void initState() {
    super.initState();
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
          _mode = 0;
        } else if (saved.method == AuthMethod.oauth2) {
          _mode = 2;
        } else {
          _tokenController.text = saved.token ?? '';
          _mode = 1;
        }
      });
    }
    if (mounted) {
      setState(() {
        _restoringCredentials = false;
      });
    }
  }

  @override
  void dispose() {
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
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return l10n.pleaseEnterValidUrl;
    }
    return null;
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
          _showError('${l10n.error}: ${l10n.failedToGetAccessToken}');
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
        _showError('${l10n.error}: $e');
      }
    } finally {
      if (mounted) setState(() => _oauthCodeExchanging = false);
      _oauthClientSecretController.clear();
    }
  }

  void _showError(String message) {
    showFToast(
      context: context,
      variant: FToastVariant.destructive,
      title: Text(message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return FScaffold(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (constraints.maxHeight - 72).clamp(
                  0,
                  double.infinity,
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: ListenableBuilder(
                    listenable: Injection.authNotifier,
                    builder: (context, child) {
                      final state = Injection.authNotifier.state;

                      if (state is AuthLoading && _restoringCredentials) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 120),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FCircularProgress(),
                              const SizedBox(height: UIConstants.md),
                              Text(
                                l10n.restoringSession,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
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
                          _buildBrand(context, theme, l10n),
                          const SizedBox(height: 24),
                          AppSurface(
                            padding: const EdgeInsets.all(20),
                            radius: 18,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppSegmentedControl(
                                  index: _mode,
                                  labels: [
                                    l10n.account,
                                    l10n.token,
                                    l10n.oauth2,
                                  ],
                                  onChanged: (index) {
                                    if (!isLoading) {
                                      setState(() => _mode = index);
                                    }
                                  },
                                ),
                                const SizedBox(height: 18),
                                if (errorMessage != null) ...[
                                  FAlert(
                                    variant: .destructive,
                                    title: Text(errorMessage),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                switch (_mode) {
                                  1 => _buildTokenForm(isLoading, l10n),
                                  2 => _buildOAuth2Form(theme, isLoading, l10n),
                                  _ => _buildBasicAuthForm(isLoading, l10n),
                                },
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'iGitea v$appVersion',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10.5,
                              color: context.palette.textSecondary.withValues(
                                alpha: 0.7,
                              ),
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
        ),
      ),
    );
  }

  Widget _buildBrand(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        const BrandMark(size: 46, iconSize: 24),
        const SizedBox(height: 14),
        Text(
          l10n.appTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
            color: context.palette.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.connectToGitea,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12.5,
            color: context.palette.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicAuthForm(bool isLoading, AppLocalizations l10n) {
    return Form(
      key: _basicFormKey,
      child: Column(
        children: [
          _buildUrlField(l10n, isLoading),
          const SizedBox(height: UIConstants.md),
          FTextFormField(
            control: FTextFieldControl.managed(controller: _usernameController),
            label: Text(l10n.username),
            hint: l10n.enterUsername,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username],
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnterUsername;
              }
              return null;
            },
          ),
          const SizedBox(height: UIConstants.md),
          FTextFormField.password(
            control: FTextFieldControl.managed(controller: _passwordController),
            label: Text(l10n.password),
            hint: l10n.enterPassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            enabled: !isLoading,
            onSubmit: (_) => _loginWithBasicAuth(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterPassword;
              }
              return null;
            },
          ),
          const SizedBox(height: UIConstants.lg),
          _buildSubmitButton(
            isLoading: isLoading,
            label: l10n.signIn,
            onPress: _loginWithBasicAuth,
          ),
        ],
      ),
    );
  }

  Widget _buildTokenForm(bool isLoading, AppLocalizations l10n) {
    return Form(
      key: _tokenFormKey,
      child: Column(
        children: [
          _buildUrlField(l10n, isLoading),
          const SizedBox(height: UIConstants.md),
          FTextFormField.password(
            control: FTextFieldControl.managed(controller: _tokenController),
            label: Text(l10n.token),
            hint: l10n.pasteAccessToken,
            textInputAction: TextInputAction.done,
            autofillHints: const [],
            enabled: !isLoading,
            onSubmit: (_) => _loginWithToken(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnterAccessToken;
              }
              return null;
            },
          ),
          const SizedBox(height: UIConstants.lg),
          _buildSubmitButton(
            isLoading: isLoading,
            label: l10n.signInWithToken,
            onPress: _loginWithToken,
          ),
        ],
      ),
    );
  }

  Widget _buildOAuth2Form(
    ThemeData theme,
    bool isLoading,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        Text(
          l10n.oauth2Description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: UIConstants.md),
        _buildUrlField(l10n, isLoading),
        const SizedBox(height: UIConstants.md),
        FTextFormField(
          control: FTextFieldControl.managed(
            controller: _oauthClientIdController,
          ),
          label: Text(l10n.oauth2ClientId),
          textInputAction: TextInputAction.next,
          enabled: !isLoading,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.requiredField;
            }
            return null;
          },
        ),
        const SizedBox(height: UIConstants.md),
        FTextFormField(
          control: FTextFieldControl.managed(
            controller: _oauthClientSecretController,
          ),
          label: Text(l10n.oauth2ClientSecret),
          textInputAction: TextInputAction.next,
          enabled: !isLoading,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.requiredField;
            }
            return null;
          },
        ),
        const SizedBox(height: UIConstants.md),
        FTextFormField(
          control: FTextFieldControl.managed(
            controller: _oauthRedirectUriController,
          ),
          label: Text(l10n.oauth2RedirectUri),
          hint: l10n.oauth2RedirectUriHint,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.url,
          enabled: !isLoading,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.requiredField;
            }
            return null;
          },
        ),
        const SizedBox(height: UIConstants.md),
        SizedBox(
          width: double.infinity,
          child: FButton(
            variant: .outline,
            onPress: isLoading ? null : _openOAuth2Authorization,
            prefix: const Icon(FIcons.externalLink),
            child: Text(l10n.oauth2Authorize),
          ),
        ),
        const SizedBox(height: UIConstants.lg),
        FTextFormField(
          control: FTextFieldControl.managed(controller: _oauthCodeController),
          label: Text(l10n.oauth2AuthorizationCode),
          hint: l10n.oauth2AuthorizationCodeHint,
          textInputAction: TextInputAction.done,
          enabled: !isLoading && !_oauthCodeExchanging,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.requiredField;
            }
            return null;
          },
        ),
        const SizedBox(height: UIConstants.lg),
        _buildSubmitButton(
          isLoading: isLoading || _oauthCodeExchanging,
          label: l10n.loginWithOAuth2,
          onPress: _exchangeOAuth2Code,
        ),
      ],
    );
  }

  Widget _buildUrlField(AppLocalizations l10n, bool isLoading) {
    return FTextFormField(
      control: FTextFieldControl.managed(controller: _baseUrlController),
      label: Text(l10n.serverUrl),
      hint: 'https://gitea.example.com',
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.url],
      enabled: !isLoading,
      validator: (value) => _validateUrl(value, l10n),
    );
  }

  Widget _buildSubmitButton({
    required bool isLoading,
    required String label,
    required VoidCallback onPress,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FButton(
        onPress: isLoading ? null : onPress,
        child: isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: FCircularProgress(size: .sm),
              )
            : Text(label),
      ),
    );
  }
}
