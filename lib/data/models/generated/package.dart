part of 'generated_models.dart';

/// Package represents a package
class Package {
  final DateTime? created_at;
  final User? creator;
  final String? html_url;
  final int? id;
  final String? name;
  final User? owner;
  final Repository? repository;
  final String? type;
  final String? version;
  const Package({
    this.created_at,
    this.creator,
    this.html_url,
    this.id,
    this.name,
    this.owner,
    this.repository,
    this.type,
    this.version,
  });
  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      created_at: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      creator: json['creator'] != null ? User.fromJson(json['creator'] as Map<String, dynamic>) : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      name: json['name'] != null ? json['name'] as String : null,
      owner: json['owner'] != null ? User.fromJson(json['owner'] as Map<String, dynamic>) : null,
      repository: json['repository'] != null ? Repository.fromJson(json['repository'] as Map<String, dynamic>) : null,
      type: json['type'] != null ? json['type'] as String : null,
      version: json['version'] != null ? json['version'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (creator != null) map['creator'] = creator!.toJson();
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (name != null) map['name'] = name!;
    if (owner != null) map['owner'] = owner!.toJson();
    if (repository != null) map['repository'] = repository!.toJson();
    if (type != null) map['type'] = type!;
    if (version != null) map['version'] = version!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Package &&
          created_at == other.created_at &&
          creator == other.creator &&
          html_url == other.html_url &&
          id == other.id &&
          name == other.name &&
          owner == other.owner &&
          repository == other.repository &&
          type == other.type &&
          version == other.version;
  @override
  int get hashCode => Object.hash(created_at, creator, html_url, id, name, owner, repository, type, version);
  @override
  String toString() => 'Package(created_at: $created_at, creator: $creator, html_url: $html_url, id: $id, name: $name, owner: $owner, repository: $repository, type: $type, version: $version)';
}
