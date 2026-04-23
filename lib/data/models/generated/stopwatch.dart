part of 'generated_models.dart';

/// StopWatch represent a running stopwatch
class StopWatch {
  final DateTime? created;
  final String? duration;
  final int? issue_index;
  final String? issue_title;
  final String? repo_name;
  final String? repo_owner_name;
  final int? seconds;
  const StopWatch({
    this.created,
    this.duration,
    this.issue_index,
    this.issue_title,
    this.repo_name,
    this.repo_owner_name,
    this.seconds,
  });
  factory StopWatch.fromJson(Map<String, dynamic> json) {
    return StopWatch(
      created: json['created'] != null ? DateTime.parse(json['created'] as String) : null,
      duration: json['duration'] != null ? json['duration'] as String : null,
      issue_index: json['issue_index'] != null ? (json['issue_index'] as num).toInt() : null,
      issue_title: json['issue_title'] != null ? json['issue_title'] as String : null,
      repo_name: json['repo_name'] != null ? json['repo_name'] as String : null,
      repo_owner_name: json['repo_owner_name'] != null ? json['repo_owner_name'] as String : null,
      seconds: json['seconds'] != null ? (json['seconds'] as num).toInt() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created != null) map['created'] = created!.toIso8601String();
    if (duration != null) map['duration'] = duration!;
    if (issue_index != null) map['issue_index'] = issue_index!;
    if (issue_title != null) map['issue_title'] = issue_title!;
    if (repo_name != null) map['repo_name'] = repo_name!;
    if (repo_owner_name != null) map['repo_owner_name'] = repo_owner_name!;
    if (seconds != null) map['seconds'] = seconds!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopWatch &&
          created == other.created &&
          duration == other.duration &&
          issue_index == other.issue_index &&
          issue_title == other.issue_title &&
          repo_name == other.repo_name &&
          repo_owner_name == other.repo_owner_name &&
          seconds == other.seconds;
  @override
  int get hashCode => Object.hash(created, duration, issue_index, issue_title, repo_name, repo_owner_name, seconds);
  @override
  String toString() => 'StopWatch(created: $created, duration: $duration, issue_index: $issue_index, issue_title: $issue_title, repo_name: $repo_name, repo_owner_name: $repo_owner_name, seconds: $seconds)';
}
