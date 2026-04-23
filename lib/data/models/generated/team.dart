part of 'generated_models.dart';

/// Team represents a team in an organization
class Team {
  final bool? can_create_org_repo;
  final String? description;
  final int? id;
  final bool? includes_all_repositories;
  final String? name;
  final Organization? organization;
  final String? permission;
  final List<String>? units;
  final Map<String, dynamic>? units_map;
  const Team({
    this.can_create_org_repo,
    this.description,
    this.id,
    this.includes_all_repositories,
    this.name,
    this.organization,
    this.permission,
    this.units,
    this.units_map,
  });
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      can_create_org_repo: json['can_create_org_repo'] != null ? json['can_create_org_repo'] as bool : null,
      description: json['description'] != null ? json['description'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      includes_all_repositories: json['includes_all_repositories'] != null ? json['includes_all_repositories'] as bool : null,
      name: json['name'] != null ? json['name'] as String : null,
      organization: json['organization'] != null ? Organization.fromJson(json['organization'] as Map<String, dynamic>) : null,
      permission: json['permission'] != null ? json['permission'] as String : null,
      units: json['units'] != null ? (json['units'] as List<dynamic>).cast<String>() : null,
      units_map: json['units_map'] != null ? json['units_map'] as Map<String, dynamic> : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (can_create_org_repo != null) map['can_create_org_repo'] = can_create_org_repo!;
    if (description != null) map['description'] = description!;
    if (id != null) map['id'] = id!;
    if (includes_all_repositories != null) map['includes_all_repositories'] = includes_all_repositories!;
    if (name != null) map['name'] = name!;
    if (organization != null) map['organization'] = organization!.toJson();
    if (permission != null) map['permission'] = permission!;
    if (units != null) map['units'] = units!;
    if (units_map != null) map['units_map'] = units_map!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Team &&
          can_create_org_repo == other.can_create_org_repo &&
          description == other.description &&
          id == other.id &&
          includes_all_repositories == other.includes_all_repositories &&
          name == other.name &&
          organization == other.organization &&
          permission == other.permission &&
          units == other.units &&
          units_map == other.units_map;
  @override
  int get hashCode => Object.hash(can_create_org_repo, description, id, includes_all_repositories, name, organization, permission, units, units_map);
  @override
  String toString() => 'Team(can_create_org_repo: $can_create_org_repo, description: $description, id: $id, includes_all_repositories: $includes_all_repositories, name: $name, organization: $organization, permission: $permission, units: $units, units_map: $units_map)';
}
