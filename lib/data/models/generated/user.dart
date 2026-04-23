part of 'generated_models.dart';

/// User represents a user
class User {
  final bool? active;
  final String? avatar_url;
  final DateTime? created;
  final String? description;
  final String? email;
  final int? followers_count;
  final int? following_count;
  final String? full_name;
  final String? html_url;
  final int? id;
  final bool? is_admin;
  final String? language;
  final DateTime? last_login;
  final String? location;
  final String? login;
  final String? login_name;
  final bool? prohibit_login;
  final bool? restricted;
  final int? source_id;
  final int? starred_repos_count;
  final String? visibility;
  final String? website;
  const User({
    this.active,
    this.avatar_url,
    this.created,
    this.description,
    this.email,
    this.followers_count,
    this.following_count,
    this.full_name,
    this.html_url,
    this.id,
    this.is_admin,
    this.language,
    this.last_login,
    this.location,
    this.login,
    this.login_name,
    this.prohibit_login,
    this.restricted,
    this.source_id,
    this.starred_repos_count,
    this.visibility,
    this.website,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      active: json['active'] != null ? json['active'] as bool : null,
      avatar_url: json['avatar_url'] != null ? json['avatar_url'] as String : null,
      created: json['created'] != null ? DateTime.parse(json['created'] as String) : null,
      description: json['description'] != null ? json['description'] as String : null,
      email: json['email'] != null ? json['email'] as String : null,
      followers_count: json['followers_count'] != null ? (json['followers_count'] as num).toInt() : null,
      following_count: json['following_count'] != null ? (json['following_count'] as num).toInt() : null,
      full_name: json['full_name'] != null ? json['full_name'] as String : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      is_admin: json['is_admin'] != null ? json['is_admin'] as bool : null,
      language: json['language'] != null ? json['language'] as String : null,
      last_login: json['last_login'] != null ? DateTime.parse(json['last_login'] as String) : null,
      location: json['location'] != null ? json['location'] as String : null,
      login: json['login'] != null ? json['login'] as String : null,
      login_name: json['login_name'] != null ? json['login_name'] as String : null,
      prohibit_login: json['prohibit_login'] != null ? json['prohibit_login'] as bool : null,
      restricted: json['restricted'] != null ? json['restricted'] as bool : null,
      source_id: json['source_id'] != null ? (json['source_id'] as num).toInt() : null,
      starred_repos_count: json['starred_repos_count'] != null ? (json['starred_repos_count'] as num).toInt() : null,
      visibility: json['visibility'] != null ? json['visibility'] as String : null,
      website: json['website'] != null ? json['website'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (active != null) map['active'] = active!;
    if (avatar_url != null) map['avatar_url'] = avatar_url!;
    if (created != null) map['created'] = created!.toIso8601String();
    if (description != null) map['description'] = description!;
    if (email != null) map['email'] = email!;
    if (followers_count != null) map['followers_count'] = followers_count!;
    if (following_count != null) map['following_count'] = following_count!;
    if (full_name != null) map['full_name'] = full_name!;
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (is_admin != null) map['is_admin'] = is_admin!;
    if (language != null) map['language'] = language!;
    if (last_login != null) map['last_login'] = last_login!.toIso8601String();
    if (location != null) map['location'] = location!;
    if (login != null) map['login'] = login!;
    if (login_name != null) map['login_name'] = login_name!;
    if (prohibit_login != null) map['prohibit_login'] = prohibit_login!;
    if (restricted != null) map['restricted'] = restricted!;
    if (source_id != null) map['source_id'] = source_id!;
    if (starred_repos_count != null) map['starred_repos_count'] = starred_repos_count!;
    if (visibility != null) map['visibility'] = visibility!;
    if (website != null) map['website'] = website!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          active == other.active &&
          avatar_url == other.avatar_url &&
          created == other.created &&
          description == other.description &&
          email == other.email &&
          followers_count == other.followers_count &&
          following_count == other.following_count &&
          full_name == other.full_name &&
          html_url == other.html_url &&
          id == other.id &&
          is_admin == other.is_admin &&
          language == other.language &&
          last_login == other.last_login &&
          location == other.location &&
          login == other.login &&
          login_name == other.login_name &&
          prohibit_login == other.prohibit_login &&
          restricted == other.restricted &&
          source_id == other.source_id &&
          starred_repos_count == other.starred_repos_count &&
          visibility == other.visibility &&
          website == other.website;
  @override
  int get hashCode => Object.hashAll([active, avatar_url, created, description, email, followers_count, following_count, full_name, html_url, id, is_admin, language, last_login, location, login, login_name, prohibit_login, restricted, source_id, starred_repos_count, visibility, website]);
  @override
  String toString() => 'User(active: $active, avatar_url: $avatar_url, created: $created, description: $description, email: $email, followers_count: $followers_count, following_count: $following_count, full_name: $full_name, html_url: $html_url, id: $id, is_admin: $is_admin, language: $language, last_login: $last_login, location: $location, login: $login, login_name: $login_name, prohibit_login: $prohibit_login, restricted: $restricted, source_id: $source_id, starred_repos_count: $starred_repos_count, visibility: $visibility, website: $website)';
}
