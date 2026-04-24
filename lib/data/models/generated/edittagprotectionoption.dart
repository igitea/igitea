part of 'generated_models.dart';

/// EditTagProtectionOption options for editing a tag protection
class EditTagProtectionOption {
  final String? name_pattern;
  final List<String>? whitelist_teams;
  final List<String>? whitelist_usernames;
  const EditTagProtectionOption({
    this.name_pattern,
    this.whitelist_teams,
    this.whitelist_usernames,
  });
  factory EditTagProtectionOption.fromJson(Map<String, dynamic> json) {
    return EditTagProtectionOption(
      name_pattern: json['name_pattern'] != null
          ? json['name_pattern'] as String
          : null,
      whitelist_teams: json['whitelist_teams'] != null
          ? (json['whitelist_teams'] as List<dynamic>).cast<String>()
          : null,
      whitelist_usernames: json['whitelist_usernames'] != null
          ? (json['whitelist_usernames'] as List<dynamic>).cast<String>()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name_pattern != null) map['name_pattern'] = name_pattern!;
    if (whitelist_teams != null) map['whitelist_teams'] = whitelist_teams!;
    if (whitelist_usernames != null)
      map['whitelist_usernames'] = whitelist_usernames!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditTagProtectionOption &&
          name_pattern == other.name_pattern &&
          whitelist_teams == other.whitelist_teams &&
          whitelist_usernames == other.whitelist_usernames;
  @override
  int get hashCode =>
      Object.hash(name_pattern, whitelist_teams, whitelist_usernames);
  @override
  String toString() =>
      'EditTagProtectionOption(name_pattern: $name_pattern, whitelist_teams: $whitelist_teams, whitelist_usernames: $whitelist_usernames)';
}
