part of 'generated_models.dart';

/// RepoCollaboratorPermission to get repository permission for a collaborator
class RepoCollaboratorPermission {
  final String? permission;
  final String? role_name;
  final User? user;
  const RepoCollaboratorPermission({
    this.permission,
    this.role_name,
    this.user,
  });
  factory RepoCollaboratorPermission.fromJson(Map<String, dynamic> json) {
    return RepoCollaboratorPermission(
      permission: json['permission'] != null
          ? json['permission'] as String
          : null,
      role_name: json['role_name'] != null ? json['role_name'] as String : null,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (permission != null) map['permission'] = permission!;
    if (role_name != null) map['role_name'] = role_name!;
    if (user != null) map['user'] = user!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepoCollaboratorPermission &&
          permission == other.permission &&
          role_name == other.role_name &&
          user == other.user;
  @override
  int get hashCode => Object.hash(permission, role_name, user);
  @override
  String toString() =>
      'RepoCollaboratorPermission(permission: $permission, role_name: $role_name, user: $user)';
}
