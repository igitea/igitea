part of 'generated_models.dart';

/// GeneralUISettings contains global ui settings exposed by API
class GeneralUISettings {
  final List<String>? allowed_reactions;
  final List<String>? custom_emojis;
  final String? default_theme;
  const GeneralUISettings({
    this.allowed_reactions,
    this.custom_emojis,
    this.default_theme,
  });
  factory GeneralUISettings.fromJson(Map<String, dynamic> json) {
    return GeneralUISettings(
      allowed_reactions: json['allowed_reactions'] != null ? (json['allowed_reactions'] as List<dynamic>).cast<String>() : null,
      custom_emojis: json['custom_emojis'] != null ? (json['custom_emojis'] as List<dynamic>).cast<String>() : null,
      default_theme: json['default_theme'] != null ? json['default_theme'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (allowed_reactions != null) map['allowed_reactions'] = allowed_reactions!;
    if (custom_emojis != null) map['custom_emojis'] = custom_emojis!;
    if (default_theme != null) map['default_theme'] = default_theme!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralUISettings &&
          allowed_reactions == other.allowed_reactions &&
          custom_emojis == other.custom_emojis &&
          default_theme == other.default_theme;
  @override
  int get hashCode => Object.hash(allowed_reactions, custom_emojis, default_theme);
  @override
  String toString() => 'GeneralUISettings(allowed_reactions: $allowed_reactions, custom_emojis: $custom_emojis, default_theme: $default_theme)';
}
