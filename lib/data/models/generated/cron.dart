part of 'generated_models.dart';

/// Cron represents a Cron task
class Cron {
  final int? exec_times;
  final String? name;
  final DateTime? next;
  final DateTime? prev;
  final String? schedule;
  const Cron({
    this.exec_times,
    this.name,
    this.next,
    this.prev,
    this.schedule,
  });
  factory Cron.fromJson(Map<String, dynamic> json) {
    return Cron(
      exec_times: json['exec_times'] != null ? (json['exec_times'] as num).toInt() : null,
      name: json['name'] != null ? json['name'] as String : null,
      next: json['next'] != null ? DateTime.parse(json['next'] as String) : null,
      prev: json['prev'] != null ? DateTime.parse(json['prev'] as String) : null,
      schedule: json['schedule'] != null ? json['schedule'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (exec_times != null) map['exec_times'] = exec_times!;
    if (name != null) map['name'] = name!;
    if (next != null) map['next'] = next!.toIso8601String();
    if (prev != null) map['prev'] = prev!.toIso8601String();
    if (schedule != null) map['schedule'] = schedule!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cron &&
          exec_times == other.exec_times &&
          name == other.name &&
          next == other.next &&
          prev == other.prev &&
          schedule == other.schedule;
  @override
  int get hashCode => Object.hash(exec_times, name, next, prev, schedule);
  @override
  String toString() => 'Cron(exec_times: $exec_times, name: $name, next: $next, prev: $prev, schedule: $schedule)';
}
