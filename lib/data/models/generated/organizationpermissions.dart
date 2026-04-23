part of 'generated_models.dart';

/// OrganizationPermissions list different users permissions on an organization
class OrganizationPermissions {
  final bool? can_create_repository;
  final bool? can_read;
  final bool? can_write;
  final bool? is_admin;
  final bool? is_owner;
  const OrganizationPermissions({
    this.can_create_repository,
    this.can_read,
    this.can_write,
    this.is_admin,
    this.is_owner,
  });
  factory OrganizationPermissions.fromJson(Map<String, dynamic> json) {
    return OrganizationPermissions(
      can_create_repository: json['can_create_repository'] != null ? json['can_create_repository'] as bool : null,
      can_read: json['can_read'] != null ? json['can_read'] as bool : null,
      can_write: json['can_write'] != null ? json['can_write'] as bool : null,
      is_admin: json['is_admin'] != null ? json['is_admin'] as bool : null,
      is_owner: json['is_owner'] != null ? json['is_owner'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (can_create_repository != null) map['can_create_repository'] = can_create_repository!;
    if (can_read != null) map['can_read'] = can_read!;
    if (can_write != null) map['can_write'] = can_write!;
    if (is_admin != null) map['is_admin'] = is_admin!;
    if (is_owner != null) map['is_owner'] = is_owner!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationPermissions &&
          can_create_repository == other.can_create_repository &&
          can_read == other.can_read &&
          can_write == other.can_write &&
          is_admin == other.is_admin &&
          is_owner == other.is_owner;
  @override
  int get hashCode => Object.hash(can_create_repository, can_read, can_write, is_admin, is_owner);
  @override
  String toString() => 'OrganizationPermissions(can_create_repository: $can_create_repository, can_read: $can_read, can_write: $can_write, is_admin: $is_admin, is_owner: $is_owner)';
}
