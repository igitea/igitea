part of 'generated_models.dart';

/// ExternalTracker represents settings for external tracker
class ExternalTracker {
  final String? external_tracker_format;
  final String? external_tracker_regexp_pattern;
  final String? external_tracker_style;
  final String? external_tracker_url;
  const ExternalTracker({
    this.external_tracker_format,
    this.external_tracker_regexp_pattern,
    this.external_tracker_style,
    this.external_tracker_url,
  });
  factory ExternalTracker.fromJson(Map<String, dynamic> json) {
    return ExternalTracker(
      external_tracker_format: json['external_tracker_format'] != null ? json['external_tracker_format'] as String : null,
      external_tracker_regexp_pattern: json['external_tracker_regexp_pattern'] != null ? json['external_tracker_regexp_pattern'] as String : null,
      external_tracker_style: json['external_tracker_style'] != null ? json['external_tracker_style'] as String : null,
      external_tracker_url: json['external_tracker_url'] != null ? json['external_tracker_url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (external_tracker_format != null) map['external_tracker_format'] = external_tracker_format!;
    if (external_tracker_regexp_pattern != null) map['external_tracker_regexp_pattern'] = external_tracker_regexp_pattern!;
    if (external_tracker_style != null) map['external_tracker_style'] = external_tracker_style!;
    if (external_tracker_url != null) map['external_tracker_url'] = external_tracker_url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExternalTracker &&
          external_tracker_format == other.external_tracker_format &&
          external_tracker_regexp_pattern == other.external_tracker_regexp_pattern &&
          external_tracker_style == other.external_tracker_style &&
          external_tracker_url == other.external_tracker_url;
  @override
  int get hashCode => Object.hash(external_tracker_format, external_tracker_regexp_pattern, external_tracker_style, external_tracker_url);
  @override
  String toString() => 'ExternalTracker(external_tracker_format: $external_tracker_format, external_tracker_regexp_pattern: $external_tracker_regexp_pattern, external_tracker_style: $external_tracker_style, external_tracker_url: $external_tracker_url)';
}
