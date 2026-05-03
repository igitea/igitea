part of 'generated_models.dart';

/// ActionWorkflowStep represents a step of a WorkflowJob
class ActionWorkflowStep {
  final DateTime? completed_at;
  final String? conclusion;
  final String? name;
  final int? number;
  final DateTime? started_at;
  final String? status;
  const ActionWorkflowStep({
    this.completed_at,
    this.conclusion,
    this.name,
    this.number,
    this.started_at,
    this.status,
  });
  factory ActionWorkflowStep.fromJson(Map<String, dynamic> json) {
    return ActionWorkflowStep(
      completed_at: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      conclusion: json['conclusion'] != null ? json['conclusion'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      number: json['number'] != null ? (json['number'] as num).toInt() : null,
      started_at: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      status: json['status'] != null ? json['status'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (completed_at != null) map['completed_at'] = completed_at!.toIso8601String();
    if (conclusion != null) map['conclusion'] = conclusion!;
    if (name != null) map['name'] = name!;
    if (number != null) map['number'] = number!;
    if (started_at != null) map['started_at'] = started_at!.toIso8601String();
    if (status != null) map['status'] = status!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionWorkflowStep &&
          completed_at == other.completed_at &&
          conclusion == other.conclusion &&
          name == other.name &&
          number == other.number &&
          started_at == other.started_at &&
          status == other.status;
  @override
  int get hashCode => Object.hash(completed_at, conclusion, name, number, started_at, status);
  @override
  String toString() => 'ActionWorkflowStep(completed_at: $completed_at, conclusion: $conclusion, name: $name, number: $number, started_at: $started_at, status: $status)';
}
