part of 'generated_models.dart';

/// ActionWorkflowJobsResponse returns ActionWorkflowJobs
class ActionWorkflowJobsResponse {
  final List<ActionWorkflowJob>? jobs;
  final int? total_count;
  const ActionWorkflowJobsResponse({this.jobs, this.total_count});
  factory ActionWorkflowJobsResponse.fromJson(Map<String, dynamic> json) {
    return ActionWorkflowJobsResponse(
      jobs: json['jobs'] != null
          ? (json['jobs'] as List<dynamic>)
                .map(
                  (e) => ActionWorkflowJob.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      total_count: json['total_count'] != null
          ? (json['total_count'] as num).toInt()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (jobs != null) map['jobs'] = jobs!.map((e) => e.toJson()).toList();
    if (total_count != null) map['total_count'] = total_count!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionWorkflowJobsResponse &&
          jobs == other.jobs &&
          total_count == other.total_count;
  @override
  int get hashCode => Object.hash(jobs, total_count);
  @override
  String toString() =>
      'ActionWorkflowJobsResponse(jobs: $jobs, total_count: $total_count)';
}
