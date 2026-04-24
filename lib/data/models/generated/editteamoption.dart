part of 'generated_models.dart';

/// EditTeamOption options for editing a team
class EditTeamOption {
  final bool? can_create_org_repo;
  final String? description;
  final bool? includes_all_repositories;
  final String? name;
  final String? permission;
  final List<String>? units;
  final Map<String, dynamic>? units_map;
  const EditTeamOption({
    this.can_create_org_repo,
    this.description,
    this.includes_all_repositories,
    this.name,
    this.permission,
    this.units,
    this.units_map,
  });
  factory EditTeamOption.fromJson(Map<String, dynamic> json) {
    return EditTeamOption(
      can_create_org_repo: json['can_create_org_repo'] != null
          ? json['can_create_org_repo'] as bool
          : null,
      description: json['description'] != null
          ? json['description'] as String
          : null,
      includes_all_repositories: json['includes_all_repositories'] != null
          ? json['includes_all_repositories'] as bool
          : null,
      name: json['name'] != null ? json['name'] as String : null,
      permission: json['permission'] != null
          ? json['permission'] as String
          : null,
      units: json['units'] != null
          ? (json['units'] as List<dynamic>).cast<String>()
          : null,
      units_map: json['units_map'] != null
          ? json['units_map'] as Map<String, dynamic>
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (can_create_org_repo != null)
      map['can_create_org_repo'] = can_create_org_repo!;
    if (description != null) map['description'] = description!;
    if (includes_all_repositories != null)
      map['includes_all_repositories'] = includes_all_repositories!;
    if (name != null) map['name'] = name!;
    if (permission != null) map['permission'] = permission!;
    if (units != null) map['units'] = units!;
    if (units_map != null) map['units_map'] = units_map!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditTeamOption &&
          can_create_org_repo == other.can_create_org_repo &&
          description == other.description &&
          includes_all_repositories == other.includes_all_repositories &&
          name == other.name &&
          permission == other.permission &&
          units == other.units &&
          units_map == other.units_map;
  @override
  int get hashCode => Object.hash(
    can_create_org_repo,
    description,
    includes_all_repositories,
    name,
    permission,
    units,
    units_map,
  );
  @override
  String toString() =>
      'EditTeamOption(can_create_org_repo: $can_create_org_repo, description: $description, includes_all_repositories: $includes_all_repositories, name: $name, permission: $permission, units: $units, units_map: $units_map)';
}
