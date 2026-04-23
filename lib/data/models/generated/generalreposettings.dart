part of 'generated_models.dart';

/// GeneralRepoSettings contains global repository settings exposed by API
class GeneralRepoSettings {
  final bool? http_git_disabled;
  final bool? lfs_disabled;
  final bool? migrations_disabled;
  final bool? mirrors_disabled;
  final bool? stars_disabled;
  final bool? time_tracking_disabled;
  const GeneralRepoSettings({
    this.http_git_disabled,
    this.lfs_disabled,
    this.migrations_disabled,
    this.mirrors_disabled,
    this.stars_disabled,
    this.time_tracking_disabled,
  });
  factory GeneralRepoSettings.fromJson(Map<String, dynamic> json) {
    return GeneralRepoSettings(
      http_git_disabled: json['http_git_disabled'] != null ? json['http_git_disabled'] as bool : null,
      lfs_disabled: json['lfs_disabled'] != null ? json['lfs_disabled'] as bool : null,
      migrations_disabled: json['migrations_disabled'] != null ? json['migrations_disabled'] as bool : null,
      mirrors_disabled: json['mirrors_disabled'] != null ? json['mirrors_disabled'] as bool : null,
      stars_disabled: json['stars_disabled'] != null ? json['stars_disabled'] as bool : null,
      time_tracking_disabled: json['time_tracking_disabled'] != null ? json['time_tracking_disabled'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (http_git_disabled != null) map['http_git_disabled'] = http_git_disabled!;
    if (lfs_disabled != null) map['lfs_disabled'] = lfs_disabled!;
    if (migrations_disabled != null) map['migrations_disabled'] = migrations_disabled!;
    if (mirrors_disabled != null) map['mirrors_disabled'] = mirrors_disabled!;
    if (stars_disabled != null) map['stars_disabled'] = stars_disabled!;
    if (time_tracking_disabled != null) map['time_tracking_disabled'] = time_tracking_disabled!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralRepoSettings &&
          http_git_disabled == other.http_git_disabled &&
          lfs_disabled == other.lfs_disabled &&
          migrations_disabled == other.migrations_disabled &&
          mirrors_disabled == other.mirrors_disabled &&
          stars_disabled == other.stars_disabled &&
          time_tracking_disabled == other.time_tracking_disabled;
  @override
  int get hashCode => Object.hash(http_git_disabled, lfs_disabled, migrations_disabled, mirrors_disabled, stars_disabled, time_tracking_disabled);
  @override
  String toString() => 'GeneralRepoSettings(http_git_disabled: $http_git_disabled, lfs_disabled: $lfs_disabled, migrations_disabled: $migrations_disabled, mirrors_disabled: $mirrors_disabled, stars_disabled: $stars_disabled, time_tracking_disabled: $time_tracking_disabled)';
}
