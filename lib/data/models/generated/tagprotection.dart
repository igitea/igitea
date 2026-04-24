part of 'generated_models.dart';

/// TagProtection represents a tag protection
class TagProtection {
  final DateTime? created_at;
  final int? id;
  final String? name_pattern;
  final DateTime? updated_at;
  final List<String>? whitelist_teams;
  final List<String>? whitelist_usernames;
  const TagProtection({
    this.created_at,
    this.id,
    this.name_pattern,
    this.updated_at,
    this.whitelist_teams,
    this.whitelist_usernames,
  });
  factory TagProtection.fromJson(Map<String, dynamic> json) {
    return TagProtection(
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      name_pattern: json['name_pattern'] != null
          ? json['name_pattern'] as String
          : null,
      updated_at: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
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
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (id != null) map['id'] = id!;
    if (name_pattern != null) map['name_pattern'] = name_pattern!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (whitelist_teams != null) map['whitelist_teams'] = whitelist_teams!;
    if (whitelist_usernames != null)
      map['whitelist_usernames'] = whitelist_usernames!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagProtection &&
          created_at == other.created_at &&
          id == other.id &&
          name_pattern == other.name_pattern &&
          updated_at == other.updated_at &&
          whitelist_teams == other.whitelist_teams &&
          whitelist_usernames == other.whitelist_usernames;
  @override
  int get hashCode => Object.hash(
    created_at,
    id,
    name_pattern,
    updated_at,
    whitelist_teams,
    whitelist_usernames,
  );
  @override
  String toString() =>
      'TagProtection(created_at: $created_at, id: $id, name_pattern: $name_pattern, updated_at: $updated_at, whitelist_teams: $whitelist_teams, whitelist_usernames: $whitelist_usernames)';
}
