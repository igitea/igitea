part of 'generated_models.dart';

/// Organization represents an organization
class Organization {
  final String? avatar_url;
  final String? description;
  final String? email;
  final String? full_name;
  final int? id;
  final String? location;
  final String? name;
  final bool? repo_admin_change_team_access;
  final String? username;
  final String? visibility;
  final String? website;
  const Organization({
    this.avatar_url,
    this.description,
    this.email,
    this.full_name,
    this.id,
    this.location,
    this.name,
    this.repo_admin_change_team_access,
    this.username,
    this.visibility,
    this.website,
  });
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      avatar_url: json['avatar_url'] != null ? json['avatar_url'] as String : null,
      description: json['description'] != null ? json['description'] as String : null,
      email: json['email'] != null ? json['email'] as String : null,
      full_name: json['full_name'] != null ? json['full_name'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      location: json['location'] != null ? json['location'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      repo_admin_change_team_access: json['repo_admin_change_team_access'] != null ? json['repo_admin_change_team_access'] as bool : null,
      username: json['username'] != null ? json['username'] as String : null,
      visibility: json['visibility'] != null ? json['visibility'] as String : null,
      website: json['website'] != null ? json['website'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (avatar_url != null) map['avatar_url'] = avatar_url!;
    if (description != null) map['description'] = description!;
    if (email != null) map['email'] = email!;
    if (full_name != null) map['full_name'] = full_name!;
    if (id != null) map['id'] = id!;
    if (location != null) map['location'] = location!;
    if (name != null) map['name'] = name!;
    if (repo_admin_change_team_access != null) map['repo_admin_change_team_access'] = repo_admin_change_team_access!;
    if (username != null) map['username'] = username!;
    if (visibility != null) map['visibility'] = visibility!;
    if (website != null) map['website'] = website!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Organization &&
          avatar_url == other.avatar_url &&
          description == other.description &&
          email == other.email &&
          full_name == other.full_name &&
          id == other.id &&
          location == other.location &&
          name == other.name &&
          repo_admin_change_team_access == other.repo_admin_change_team_access &&
          username == other.username &&
          visibility == other.visibility &&
          website == other.website;
  @override
  int get hashCode => Object.hash(avatar_url, description, email, full_name, id, location, name, repo_admin_change_team_access, username, visibility, website);
  @override
  String toString() => 'Organization(avatar_url: $avatar_url, description: $description, email: $email, full_name: $full_name, id: $id, location: $location, name: $name, repo_admin_change_team_access: $repo_admin_change_team_access, username: $username, visibility: $visibility, website: $website)';
}
