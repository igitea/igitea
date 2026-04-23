part of 'generated_models.dart';

/// ActionTaskResponse returns a ActionTask
class ActionTaskResponse {
  final int? total_count;
  final List<ActionTask>? workflow_runs;
  const ActionTaskResponse({
    this.total_count,
    this.workflow_runs,
  });
  factory ActionTaskResponse.fromJson(Map<String, dynamic> json) {
    return ActionTaskResponse(
      total_count: json['total_count'] != null ? (json['total_count'] as num).toInt() : null,
      workflow_runs: json['workflow_runs'] != null ? (json['workflow_runs'] as List<dynamic>).map((e) => ActionTask.fromJson(e as Map<String, dynamic>)).toList() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (total_count != null) map['total_count'] = total_count!;
    if (workflow_runs != null) map['workflow_runs'] = workflow_runs!.map((e) => e.toJson()).toList();
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionTaskResponse &&
          total_count == other.total_count &&
          workflow_runs == other.workflow_runs;
  @override
  int get hashCode => Object.hash(total_count, workflow_runs);
  @override
  String toString() => 'ActionTaskResponse(total_count: $total_count, workflow_runs: $workflow_runs)';
}
