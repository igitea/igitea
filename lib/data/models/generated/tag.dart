part of 'generated_models.dart';

/// Tag represents a repository tag
class Tag {
  final CommitMeta? commit;
  final String? id;
  final String? message;
  final String? name;
  final String? tarball_url;
  final String? zipball_url;
  const Tag({
    this.commit,
    this.id,
    this.message,
    this.name,
    this.tarball_url,
    this.zipball_url,
  });
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      commit: json['commit'] != null
          ? CommitMeta.fromJson(json['commit'] as Map<String, dynamic>)
          : null,
      id: json['id'] != null ? json['id'] as String : null,
      message: json['message'] != null ? json['message'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      tarball_url: json['tarball_url'] != null
          ? json['tarball_url'] as String
          : null,
      zipball_url: json['zipball_url'] != null
          ? json['zipball_url'] as String
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (commit != null) map['commit'] = commit!.toJson();
    if (id != null) map['id'] = id!;
    if (message != null) map['message'] = message!;
    if (name != null) map['name'] = name!;
    if (tarball_url != null) map['tarball_url'] = tarball_url!;
    if (zipball_url != null) map['zipball_url'] = zipball_url!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag &&
          commit == other.commit &&
          id == other.id &&
          message == other.message &&
          name == other.name &&
          tarball_url == other.tarball_url &&
          zipball_url == other.zipball_url;
  @override
  int get hashCode =>
      Object.hash(commit, id, message, name, tarball_url, zipball_url);
  @override
  String toString() =>
      'Tag(commit: $commit, id: $id, message: $message, name: $name, tarball_url: $tarball_url, zipball_url: $zipball_url)';
}
