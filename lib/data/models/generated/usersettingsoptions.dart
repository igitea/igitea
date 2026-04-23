part of 'generated_models.dart';

/// UserSettingsOptions represents options to change user settings
class UserSettingsOptions {
  final String? description;
  final String? diff_view_style;
  final String? full_name;
  final bool? hide_activity;
  final bool? hide_email;
  final String? language;
  final String? location;
  final String? theme;
  final String? website;
  const UserSettingsOptions({
    this.description,
    this.diff_view_style,
    this.full_name,
    this.hide_activity,
    this.hide_email,
    this.language,
    this.location,
    this.theme,
    this.website,
  });
  factory UserSettingsOptions.fromJson(Map<String, dynamic> json) {
    return UserSettingsOptions(
      description: json['description'] != null ? json['description'] as String : null,
      diff_view_style: json['diff_view_style'] != null ? json['diff_view_style'] as String : null,
      full_name: json['full_name'] != null ? json['full_name'] as String : null,
      hide_activity: json['hide_activity'] != null ? json['hide_activity'] as bool : null,
      hide_email: json['hide_email'] != null ? json['hide_email'] as bool : null,
      language: json['language'] != null ? json['language'] as String : null,
      location: json['location'] != null ? json['location'] as String : null,
      theme: json['theme'] != null ? json['theme'] as String : null,
      website: json['website'] != null ? json['website'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (description != null) map['description'] = description!;
    if (diff_view_style != null) map['diff_view_style'] = diff_view_style!;
    if (full_name != null) map['full_name'] = full_name!;
    if (hide_activity != null) map['hide_activity'] = hide_activity!;
    if (hide_email != null) map['hide_email'] = hide_email!;
    if (language != null) map['language'] = language!;
    if (location != null) map['location'] = location!;
    if (theme != null) map['theme'] = theme!;
    if (website != null) map['website'] = website!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsOptions &&
          description == other.description &&
          diff_view_style == other.diff_view_style &&
          full_name == other.full_name &&
          hide_activity == other.hide_activity &&
          hide_email == other.hide_email &&
          language == other.language &&
          location == other.location &&
          theme == other.theme &&
          website == other.website;
  @override
  int get hashCode => Object.hash(description, diff_view_style, full_name, hide_activity, hide_email, language, location, theme, website);
  @override
  String toString() => 'UserSettingsOptions(description: $description, diff_view_style: $diff_view_style, full_name: $full_name, hide_activity: $hide_activity, hide_email: $hide_email, language: $language, location: $location, theme: $theme, website: $website)';
}
