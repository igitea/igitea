part of 'generated_models.dart';

/// RepositoryMeta basic repository information
class RepositoryMeta {
  final String? full_name;
  final int? id;
  final String? name;
  final String? owner;
  const RepositoryMeta({
    this.full_name,
    this.id,
    this.name,
    this.owner,
  });
  factory RepositoryMeta.fromJson(Map<String, dynamic> json) {
    return RepositoryMeta(
      full_name: json['full_name'] != null ? json['full_name'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      name: json['name'] != null ? json['name'] as String : null,
      owner: json['owner'] != null ? json['owner'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (full_name != null) map['full_name'] = full_name!;
    if (id != null) map['id'] = id!;
    if (name != null) map['name'] = name!;
    if (owner != null) map['owner'] = owner!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepositoryMeta &&
          full_name == other.full_name &&
          id == other.id &&
          name == other.name &&
          owner == other.owner;
  @override
  int get hashCode => Object.hash(full_name, id, name, owner);
  @override
  String toString() => 'RepositoryMeta(full_name: $full_name, id: $id, name: $name, owner: $owner)';
}
