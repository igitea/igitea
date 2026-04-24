part of 'generated_models.dart';

/// EditOrgOption options for editing an organization
class EditOrgOption {
  final String? description;
  final String? email;
  final String? full_name;
  final String? location;
  final bool? repo_admin_change_team_access;
  final String? visibility;
  final String? website;
  const EditOrgOption({
    this.description,
    this.email,
    this.full_name,
    this.location,
    this.repo_admin_change_team_access,
    this.visibility,
    this.website,
  });
  factory EditOrgOption.fromJson(Map<String, dynamic> json) {
    return EditOrgOption(
      description: json['description'] != null
          ? json['description'] as String
          : null,
      email: json['email'] != null ? json['email'] as String : null,
      full_name: json['full_name'] != null ? json['full_name'] as String : null,
      location: json['location'] != null ? json['location'] as String : null,
      repo_admin_change_team_access:
          json['repo_admin_change_team_access'] != null
          ? json['repo_admin_change_team_access'] as bool
          : null,
      visibility: json['visibility'] != null
          ? json['visibility'] as String
          : null,
      website: json['website'] != null ? json['website'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (description != null) map['description'] = description!;
    if (email != null) map['email'] = email!;
    if (full_name != null) map['full_name'] = full_name!;
    if (location != null) map['location'] = location!;
    if (repo_admin_change_team_access != null)
      map['repo_admin_change_team_access'] = repo_admin_change_team_access!;
    if (visibility != null) map['visibility'] = visibility!;
    if (website != null) map['website'] = website!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditOrgOption &&
          description == other.description &&
          email == other.email &&
          full_name == other.full_name &&
          location == other.location &&
          repo_admin_change_team_access ==
              other.repo_admin_change_team_access &&
          visibility == other.visibility &&
          website == other.website;
  @override
  int get hashCode => Object.hash(
    description,
    email,
    full_name,
    location,
    repo_admin_change_team_access,
    visibility,
    website,
  );
  @override
  String toString() =>
      'EditOrgOption(description: $description, email: $email, full_name: $full_name, location: $location, repo_admin_change_team_access: $repo_admin_change_team_access, visibility: $visibility, website: $website)';
}
