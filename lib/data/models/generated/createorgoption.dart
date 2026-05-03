part of 'generated_models.dart';

/// CreateOrgOption options for creating an organization
class CreateOrgOption {
  final String? description;
  final String? email;
  final String? full_name;
  final String? location;
  final bool? repo_admin_change_team_access;
  final String? username;
  final String? visibility;
  final String? website;
  const CreateOrgOption({
    this.description,
    this.email,
    this.full_name,
    this.location,
    this.repo_admin_change_team_access,
    this.username,
    this.visibility,
    this.website,
  });
  factory CreateOrgOption.fromJson(Map<String, dynamic> json) {
    return CreateOrgOption(
      description: json['description'] != null ? json['description'] as String : null,
      email: json['email'] != null ? json['email'] as String : null,
      full_name: json['full_name'] != null ? json['full_name'] as String : null,
      location: json['location'] != null ? json['location'] as String : null,
      repo_admin_change_team_access: json['repo_admin_change_team_access'] != null ? json['repo_admin_change_team_access'] as bool : null,
      username: json['username'] != null ? json['username'] as String : null,
      visibility: json['visibility'] != null ? json['visibility'] as String : null,
      website: json['website'] != null ? json['website'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (description != null) map['description'] = description!;
    if (email != null) map['email'] = email!;
    if (full_name != null) map['full_name'] = full_name!;
    if (location != null) map['location'] = location!;
    if (repo_admin_change_team_access != null) map['repo_admin_change_team_access'] = repo_admin_change_team_access!;
    if (username != null) map['username'] = username!;
    if (visibility != null) map['visibility'] = visibility!;
    if (website != null) map['website'] = website!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateOrgOption &&
          description == other.description &&
          email == other.email &&
          full_name == other.full_name &&
          location == other.location &&
          repo_admin_change_team_access == other.repo_admin_change_team_access &&
          username == other.username &&
          visibility == other.visibility &&
          website == other.website;
  @override
  int get hashCode => Object.hash(description, email, full_name, location, repo_admin_change_team_access, username, visibility, website);
  @override
  String toString() => 'CreateOrgOption(description: $description, email: $email, full_name: $full_name, location: $location, repo_admin_change_team_access: $repo_admin_change_team_access, username: $username, visibility: $visibility, website: $website)';
}
