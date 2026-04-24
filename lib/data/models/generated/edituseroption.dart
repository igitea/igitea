part of 'generated_models.dart';

/// EditUserOption edit user options
class EditUserOption {
  final bool? active;
  final bool? admin;
  final bool? allow_create_organization;
  final bool? allow_git_hook;
  final bool? allow_import_local;
  final String? description;
  final String? email;
  final String? full_name;
  final String? location;
  final String? login_name;
  final int? max_repo_creation;
  final bool? must_change_password;
  final String? password;
  final bool? prohibit_login;
  final bool? restricted;
  final int? source_id;
  final String? visibility;
  final String? website;
  const EditUserOption({
    this.active,
    this.admin,
    this.allow_create_organization,
    this.allow_git_hook,
    this.allow_import_local,
    this.description,
    this.email,
    this.full_name,
    this.location,
    this.login_name,
    this.max_repo_creation,
    this.must_change_password,
    this.password,
    this.prohibit_login,
    this.restricted,
    this.source_id,
    this.visibility,
    this.website,
  });
  factory EditUserOption.fromJson(Map<String, dynamic> json) {
    return EditUserOption(
      active: json['active'] != null ? json['active'] as bool : null,
      admin: json['admin'] != null ? json['admin'] as bool : null,
      allow_create_organization: json['allow_create_organization'] != null
          ? json['allow_create_organization'] as bool
          : null,
      allow_git_hook: json['allow_git_hook'] != null
          ? json['allow_git_hook'] as bool
          : null,
      allow_import_local: json['allow_import_local'] != null
          ? json['allow_import_local'] as bool
          : null,
      description: json['description'] != null
          ? json['description'] as String
          : null,
      email: json['email'] != null ? json['email'] as String : null,
      full_name: json['full_name'] != null ? json['full_name'] as String : null,
      location: json['location'] != null ? json['location'] as String : null,
      login_name: json['login_name'] != null
          ? json['login_name'] as String
          : null,
      max_repo_creation: json['max_repo_creation'] != null
          ? (json['max_repo_creation'] as num).toInt()
          : null,
      must_change_password: json['must_change_password'] != null
          ? json['must_change_password'] as bool
          : null,
      password: json['password'] != null ? json['password'] as String : null,
      prohibit_login: json['prohibit_login'] != null
          ? json['prohibit_login'] as bool
          : null,
      restricted: json['restricted'] != null
          ? json['restricted'] as bool
          : null,
      source_id: json['source_id'] != null
          ? (json['source_id'] as num).toInt()
          : null,
      visibility: json['visibility'] != null
          ? json['visibility'] as String
          : null,
      website: json['website'] != null ? json['website'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (active != null) map['active'] = active!;
    if (admin != null) map['admin'] = admin!;
    if (allow_create_organization != null)
      map['allow_create_organization'] = allow_create_organization!;
    if (allow_git_hook != null) map['allow_git_hook'] = allow_git_hook!;
    if (allow_import_local != null)
      map['allow_import_local'] = allow_import_local!;
    if (description != null) map['description'] = description!;
    if (email != null) map['email'] = email!;
    if (full_name != null) map['full_name'] = full_name!;
    if (location != null) map['location'] = location!;
    if (login_name != null) map['login_name'] = login_name!;
    if (max_repo_creation != null)
      map['max_repo_creation'] = max_repo_creation!;
    if (must_change_password != null)
      map['must_change_password'] = must_change_password!;
    if (password != null) map['password'] = password!;
    if (prohibit_login != null) map['prohibit_login'] = prohibit_login!;
    if (restricted != null) map['restricted'] = restricted!;
    if (source_id != null) map['source_id'] = source_id!;
    if (visibility != null) map['visibility'] = visibility!;
    if (website != null) map['website'] = website!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditUserOption &&
          active == other.active &&
          admin == other.admin &&
          allow_create_organization == other.allow_create_organization &&
          allow_git_hook == other.allow_git_hook &&
          allow_import_local == other.allow_import_local &&
          description == other.description &&
          email == other.email &&
          full_name == other.full_name &&
          location == other.location &&
          login_name == other.login_name &&
          max_repo_creation == other.max_repo_creation &&
          must_change_password == other.must_change_password &&
          password == other.password &&
          prohibit_login == other.prohibit_login &&
          restricted == other.restricted &&
          source_id == other.source_id &&
          visibility == other.visibility &&
          website == other.website;
  @override
  int get hashCode => Object.hash(
    active,
    admin,
    allow_create_organization,
    allow_git_hook,
    allow_import_local,
    description,
    email,
    full_name,
    location,
    login_name,
    max_repo_creation,
    must_change_password,
    password,
    prohibit_login,
    restricted,
    source_id,
    visibility,
    website,
  );
  @override
  String toString() =>
      'EditUserOption(active: $active, admin: $admin, allow_create_organization: $allow_create_organization, allow_git_hook: $allow_git_hook, allow_import_local: $allow_import_local, description: $description, email: $email, full_name: $full_name, location: $location, login_name: $login_name, max_repo_creation: $max_repo_creation, must_change_password: $must_change_password, password: $password, prohibit_login: $prohibit_login, restricted: $restricted, source_id: $source_id, visibility: $visibility, website: $website)';
}
