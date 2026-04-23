part of 'generated_models.dart';

/// CreateOAuth2ApplicationOptions holds options to create an oauth2 application
class CreateOAuth2ApplicationOptions {
  final bool? confidential_client;
  final String? name;
  final List<String>? redirect_uris;
  final bool? skip_secondary_authorization;
  const CreateOAuth2ApplicationOptions({
    this.confidential_client,
    this.name,
    this.redirect_uris,
    this.skip_secondary_authorization,
  });
  factory CreateOAuth2ApplicationOptions.fromJson(Map<String, dynamic> json) {
    return CreateOAuth2ApplicationOptions(
      confidential_client: json['confidential_client'] != null ? json['confidential_client'] as bool : null,
      name: json['name'] != null ? json['name'] as String : null,
      redirect_uris: json['redirect_uris'] != null ? (json['redirect_uris'] as List<dynamic>).cast<String>() : null,
      skip_secondary_authorization: json['skip_secondary_authorization'] != null ? json['skip_secondary_authorization'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (confidential_client != null) map['confidential_client'] = confidential_client!;
    if (name != null) map['name'] = name!;
    if (redirect_uris != null) map['redirect_uris'] = redirect_uris!;
    if (skip_secondary_authorization != null) map['skip_secondary_authorization'] = skip_secondary_authorization!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateOAuth2ApplicationOptions &&
          confidential_client == other.confidential_client &&
          name == other.name &&
          redirect_uris == other.redirect_uris &&
          skip_secondary_authorization == other.skip_secondary_authorization;
  @override
  int get hashCode => Object.hash(confidential_client, name, redirect_uris, skip_secondary_authorization);
  @override
  String toString() => 'CreateOAuth2ApplicationOptions(confidential_client: $confidential_client, name: $name, redirect_uris: $redirect_uris, skip_secondary_authorization: $skip_secondary_authorization)';
}
