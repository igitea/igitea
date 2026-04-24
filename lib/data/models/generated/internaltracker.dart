part of 'generated_models.dart';

/// InternalTracker represents settings for internal tracker
class InternalTracker {
  final bool? allow_only_contributors_to_track_time;
  final bool? enable_issue_dependencies;
  final bool? enable_time_tracker;
  const InternalTracker({
    this.allow_only_contributors_to_track_time,
    this.enable_issue_dependencies,
    this.enable_time_tracker,
  });
  factory InternalTracker.fromJson(Map<String, dynamic> json) {
    return InternalTracker(
      allow_only_contributors_to_track_time:
          json['allow_only_contributors_to_track_time'] != null
          ? json['allow_only_contributors_to_track_time'] as bool
          : null,
      enable_issue_dependencies: json['enable_issue_dependencies'] != null
          ? json['enable_issue_dependencies'] as bool
          : null,
      enable_time_tracker: json['enable_time_tracker'] != null
          ? json['enable_time_tracker'] as bool
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (allow_only_contributors_to_track_time != null)
      map['allow_only_contributors_to_track_time'] =
          allow_only_contributors_to_track_time!;
    if (enable_issue_dependencies != null)
      map['enable_issue_dependencies'] = enable_issue_dependencies!;
    if (enable_time_tracker != null)
      map['enable_time_tracker'] = enable_time_tracker!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InternalTracker &&
          allow_only_contributors_to_track_time ==
              other.allow_only_contributors_to_track_time &&
          enable_issue_dependencies == other.enable_issue_dependencies &&
          enable_time_tracker == other.enable_time_tracker;
  @override
  int get hashCode => Object.hash(
    allow_only_contributors_to_track_time,
    enable_issue_dependencies,
    enable_time_tracker,
  );
  @override
  String toString() =>
      'InternalTracker(allow_only_contributors_to_track_time: $allow_only_contributors_to_track_time, enable_issue_dependencies: $enable_issue_dependencies, enable_time_tracker: $enable_time_tracker)';
}
