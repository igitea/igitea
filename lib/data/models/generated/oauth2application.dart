part of 'generated_models.dart';

/// OAuth2Application represents an OAuth2 application.
class OAuth2Application {
  final String? client_id;
  final String? client_secret;
  final bool? confidential_client;
  final DateTime? created;
  final int? id;
  final String? name;
  final List<String>? redirect_uris;
  final bool? skip_secondary_authorization;
  const OAuth2Application({
    this.client_id,
    this.client_secret,
    this.confidential_client,
    this.created,
    this.id,
    this.name,
    this.redirect_uris,
    this.skip_secondary_authorization,
  });
  factory OAuth2Application.fromJson(Map<String, dynamic> json) {
    return OAuth2Application(
      client_id: json['client_id'] != null ? json['client_id'] as String : null,
      client_secret: json['client_secret'] != null ? json['client_secret'] as String : null,
      confidential_client: json['confidential_client'] != null ? json['confidential_client'] as bool : null,
      created: json['created'] != null ? DateTime.parse(json['created'] as String) : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      name: json['name'] != null ? json['name'] as String : null,
      redirect_uris: json['redirect_uris'] != null ? (json['redirect_uris'] as List<dynamic>).cast<String>() : null,
      skip_secondary_authorization: json['skip_secondary_authorization'] != null ? json['skip_secondary_authorization'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (client_id != null) map['client_id'] = client_id!;
    if (client_secret != null) map['client_secret'] = client_secret!;
    if (confidential_client != null) map['confidential_client'] = confidential_client!;
    if (created != null) map['created'] = created!.toIso8601String();
    if (id != null) map['id'] = id!;
    if (name != null) map['name'] = name!;
    if (redirect_uris != null) map['redirect_uris'] = redirect_uris!;
    if (skip_secondary_authorization != null) map['skip_secondary_authorization'] = skip_secondary_authorization!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OAuth2Application &&
          client_id == other.client_id &&
          client_secret == other.client_secret &&
          confidential_client == other.confidential_client &&
          created == other.created &&
          id == other.id &&
          name == other.name &&
          redirect_uris == other.redirect_uris &&
          skip_secondary_authorization == other.skip_secondary_authorization;
  @override
  int get hashCode => Object.hash(client_id, client_secret, confidential_client, created, id, name, redirect_uris, skip_secondary_authorization);
  @override
  String toString() => 'OAuth2Application(client_id: $client_id, client_secret: $client_secret, confidential_client: $confidential_client, created: $created, id: $id, name: $name, redirect_uris: $redirect_uris, skip_secondary_authorization: $skip_secondary_authorization)';
}
