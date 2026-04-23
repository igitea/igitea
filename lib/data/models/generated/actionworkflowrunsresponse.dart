part of 'generated_models.dart';

/// ActionWorkflowRunsResponse returns ActionWorkflowRuns
class ActionWorkflowRunsResponse {
  final int? total_count;
  final List<ActionWorkflowRun>? workflow_runs;
  const ActionWorkflowRunsResponse({
    this.total_count,
    this.workflow_runs,
  });
  factory ActionWorkflowRunsResponse.fromJson(Map<String, dynamic> json) {
    return ActionWorkflowRunsResponse(
      total_count: json['total_count'] != null ? (json['total_count'] as num).toInt() : null,
      workflow_runs: json['workflow_runs'] != null ? (json['workflow_runs'] as List<dynamic>).map((e) => ActionWorkflowRun.fromJson(e as Map<String, dynamic>)).toList() : null,
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
      other is ActionWorkflowRunsResponse &&
          total_count == other.total_count &&
          workflow_runs == other.workflow_runs;
  @override
  int get hashCode => Object.hash(total_count, workflow_runs);
  @override
  String toString() => 'ActionWorkflowRunsResponse(total_count: $total_count, workflow_runs: $workflow_runs)';
}
