part of 'generated_models.dart';

/// PublicKey publickey is a user key to push code to repository
class PublicKey {
  final DateTime? created_at;
  final String? fingerprint;
  final int? id;
  final String? key;
  final String? key_type;
  final DateTime? last_used_at;
  final bool? read_only;
  final String? title;
  final String? url;
  final User? user;
  const PublicKey({
    this.created_at,
    this.fingerprint,
    this.id,
    this.key,
    this.key_type,
    this.last_used_at,
    this.read_only,
    this.title,
    this.url,
    this.user,
  });
  factory PublicKey.fromJson(Map<String, dynamic> json) {
    return PublicKey(
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      fingerprint: json['fingerprint'] != null
          ? json['fingerprint'] as String
          : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      key: json['key'] != null ? json['key'] as String : null,
      key_type: json['key_type'] != null ? json['key_type'] as String : null,
      last_used_at: json['last_used_at'] != null
          ? DateTime.parse(json['last_used_at'] as String)
          : null,
      read_only: json['read_only'] != null ? json['read_only'] as bool : null,
      title: json['title'] != null ? json['title'] as String : null,
      url: json['url'] != null ? json['url'] as String : null,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (fingerprint != null) map['fingerprint'] = fingerprint!;
    if (id != null) map['id'] = id!;
    if (key != null) map['key'] = key!;
    if (key_type != null) map['key_type'] = key_type!;
    if (last_used_at != null)
      map['last_used_at'] = last_used_at!.toIso8601String();
    if (read_only != null) map['read_only'] = read_only!;
    if (title != null) map['title'] = title!;
    if (url != null) map['url'] = url!;
    if (user != null) map['user'] = user!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublicKey &&
          created_at == other.created_at &&
          fingerprint == other.fingerprint &&
          id == other.id &&
          key == other.key &&
          key_type == other.key_type &&
          last_used_at == other.last_used_at &&
          read_only == other.read_only &&
          title == other.title &&
          url == other.url &&
          user == other.user;
  @override
  int get hashCode => Object.hash(
    created_at,
    fingerprint,
    id,
    key,
    key_type,
    last_used_at,
    read_only,
    title,
    url,
    user,
  );
  @override
  String toString() =>
      'PublicKey(created_at: $created_at, fingerprint: $fingerprint, id: $id, key: $key, key_type: $key_type, last_used_at: $last_used_at, read_only: $read_only, title: $title, url: $url, user: $user)';
}
