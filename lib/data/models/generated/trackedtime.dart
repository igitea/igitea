part of 'generated_models.dart';

/// TrackedTime worked time for an issue / pr
class TrackedTime {
  final DateTime? created;
  final int? id;
  final Issue? issue;
  final int? issue_id;
  final int? time;
  final int? user_id;
  final String? user_name;
  const TrackedTime({
    this.created,
    this.id,
    this.issue,
    this.issue_id,
    this.time,
    this.user_id,
    this.user_name,
  });
  factory TrackedTime.fromJson(Map<String, dynamic> json) {
    return TrackedTime(
      created: json['created'] != null
          ? DateTime.parse(json['created'] as String)
          : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      issue: json['issue'] != null
          ? Issue.fromJson(json['issue'] as Map<String, dynamic>)
          : null,
      issue_id: json['issue_id'] != null
          ? (json['issue_id'] as num).toInt()
          : null,
      time: json['time'] != null ? (json['time'] as num).toInt() : null,
      user_id: json['user_id'] != null
          ? (json['user_id'] as num).toInt()
          : null,
      user_name: json['user_name'] != null ? json['user_name'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created != null) map['created'] = created!.toIso8601String();
    if (id != null) map['id'] = id!;
    if (issue != null) map['issue'] = issue!.toJson();
    if (issue_id != null) map['issue_id'] = issue_id!;
    if (time != null) map['time'] = time!;
    if (user_id != null) map['user_id'] = user_id!;
    if (user_name != null) map['user_name'] = user_name!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackedTime &&
          created == other.created &&
          id == other.id &&
          issue == other.issue &&
          issue_id == other.issue_id &&
          time == other.time &&
          user_id == other.user_id &&
          user_name == other.user_name;
  @override
  int get hashCode =>
      Object.hash(created, id, issue, issue_id, time, user_id, user_name);
  @override
  String toString() =>
      'TrackedTime(created: $created, id: $id, issue: $issue, issue_id: $issue_id, time: $time, user_id: $user_id, user_name: $user_name)';
}
