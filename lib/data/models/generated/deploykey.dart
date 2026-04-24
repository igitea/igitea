part of 'generated_models.dart';

/// DeployKey a deploy key
class DeployKey {
  final DateTime? created_at;
  final String? fingerprint;
  final int? id;
  final String? key;
  final int? key_id;
  final bool? read_only;
  final Repository? repository;
  final String? title;
  final String? url;
  const DeployKey({
    this.created_at,
    this.fingerprint,
    this.id,
    this.key,
    this.key_id,
    this.read_only,
    this.repository,
    this.title,
    this.url,
  });
  factory DeployKey.fromJson(Map<String, dynamic> json) {
    return DeployKey(
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      fingerprint: json['fingerprint'] != null
          ? json['fingerprint'] as String
          : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      key: json['key'] != null ? json['key'] as String : null,
      key_id: json['key_id'] != null ? (json['key_id'] as num).toInt() : null,
      read_only: json['read_only'] != null ? json['read_only'] as bool : null,
      repository: json['repository'] != null
          ? Repository.fromJson(json['repository'] as Map<String, dynamic>)
          : null,
      title: json['title'] != null ? json['title'] as String : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (fingerprint != null) map['fingerprint'] = fingerprint!;
    if (id != null) map['id'] = id!;
    if (key != null) map['key'] = key!;
    if (key_id != null) map['key_id'] = key_id!;
    if (read_only != null) map['read_only'] = read_only!;
    if (repository != null) map['repository'] = repository!.toJson();
    if (title != null) map['title'] = title!;
    if (url != null) map['url'] = url!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeployKey &&
          created_at == other.created_at &&
          fingerprint == other.fingerprint &&
          id == other.id &&
          key == other.key &&
          key_id == other.key_id &&
          read_only == other.read_only &&
          repository == other.repository &&
          title == other.title &&
          url == other.url;
  @override
  int get hashCode => Object.hash(
    created_at,
    fingerprint,
    id,
    key,
    key_id,
    read_only,
    repository,
    title,
    url,
  );
  @override
  String toString() =>
      'DeployKey(created_at: $created_at, fingerprint: $fingerprint, id: $id, key: $key, key_id: $key_id, read_only: $read_only, repository: $repository, title: $title, url: $url)';
}
