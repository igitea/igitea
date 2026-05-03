part of 'generated_models.dart';

/// ActionVariable return value of the query API
class ActionVariable {
  final String? data;
  final String? description;
  final String? name;
  final int? owner_id;
  final int? repo_id;
  const ActionVariable({
    this.data,
    this.description,
    this.name,
    this.owner_id,
    this.repo_id,
  });
  factory ActionVariable.fromJson(Map<String, dynamic> json) {
    return ActionVariable(
      data: json['data'] != null ? json['data'] as String : null,
      description: json['description'] != null ? json['description'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      owner_id: json['owner_id'] != null ? (json['owner_id'] as num).toInt() : null,
      repo_id: json['repo_id'] != null ? (json['repo_id'] as num).toInt() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) map['data'] = data!;
    if (description != null) map['description'] = description!;
    if (name != null) map['name'] = name!;
    if (owner_id != null) map['owner_id'] = owner_id!;
    if (repo_id != null) map['repo_id'] = repo_id!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionVariable &&
          data == other.data &&
          description == other.description &&
          name == other.name &&
          owner_id == other.owner_id &&
          repo_id == other.repo_id;
  @override
  int get hashCode => Object.hash(data, description, name, owner_id, repo_id);
  @override
  String toString() => 'ActionVariable(data: $data, description: $description, name: $name, owner_id: $owner_id, repo_id: $repo_id)';
}
