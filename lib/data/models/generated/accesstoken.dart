part of 'generated_models.dart';

/// AccessToken represents an API access token.
class AccessToken {
  final DateTime? created_at;
  final int? id;
  final DateTime? last_used_at;
  final String? name;
  final List<String>? scopes;
  final String? sha1;
  final String? token_last_eight;
  const AccessToken({
    this.created_at,
    this.id,
    this.last_used_at,
    this.name,
    this.scopes,
    this.sha1,
    this.token_last_eight,
  });
  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      last_used_at: json['last_used_at'] != null
          ? DateTime.parse(json['last_used_at'] as String)
          : null,
      name: json['name'] != null ? json['name'] as String : null,
      scopes: json['scopes'] != null
          ? (json['scopes'] as List<dynamic>).cast<String>()
          : null,
      sha1: json['sha1'] != null ? json['sha1'] as String : null,
      token_last_eight: json['token_last_eight'] != null
          ? json['token_last_eight'] as String
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (id != null) map['id'] = id!;
    if (last_used_at != null)
      map['last_used_at'] = last_used_at!.toIso8601String();
    if (name != null) map['name'] = name!;
    if (scopes != null) map['scopes'] = scopes!;
    if (sha1 != null) map['sha1'] = sha1!;
    if (token_last_eight != null) map['token_last_eight'] = token_last_eight!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessToken &&
          created_at == other.created_at &&
          id == other.id &&
          last_used_at == other.last_used_at &&
          name == other.name &&
          scopes == other.scopes &&
          sha1 == other.sha1 &&
          token_last_eight == other.token_last_eight;
  @override
  int get hashCode => Object.hash(
    created_at,
    id,
    last_used_at,
    name,
    scopes,
    sha1,
    token_last_eight,
  );
  @override
  String toString() =>
      'AccessToken(created_at: $created_at, id: $id, last_used_at: $last_used_at, name: $name, scopes: $scopes, sha1: $sha1, token_last_eight: $token_last_eight)';
}
