part of 'generated_models.dart';

/// NodeInfoSoftware contains Metadata about server software in use
class NodeInfoSoftware {
  final String? homepage;
  final String? name;
  final String? repository;
  final String? version;
  const NodeInfoSoftware({
    this.homepage,
    this.name,
    this.repository,
    this.version,
  });
  factory NodeInfoSoftware.fromJson(Map<String, dynamic> json) {
    return NodeInfoSoftware(
      homepage: json['homepage'] != null ? json['homepage'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      repository: json['repository'] != null ? json['repository'] as String : null,
      version: json['version'] != null ? json['version'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (homepage != null) map['homepage'] = homepage!;
    if (name != null) map['name'] = name!;
    if (repository != null) map['repository'] = repository!;
    if (version != null) map['version'] = version!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeInfoSoftware &&
          homepage == other.homepage &&
          name == other.name &&
          repository == other.repository &&
          version == other.version;
  @override
  int get hashCode => Object.hash(homepage, name, repository, version);
  @override
  String toString() => 'NodeInfoSoftware(homepage: $homepage, name: $name, repository: $repository, version: $version)';
}
