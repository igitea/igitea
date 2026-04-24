part of 'generated_models.dart';

/// ActionWorkflowResponse returns a ActionWorkflow
class ActionWorkflowResponse {
  final int? total_count;
  final List<ActionWorkflow>? workflows;
  const ActionWorkflowResponse({this.total_count, this.workflows});
  factory ActionWorkflowResponse.fromJson(Map<String, dynamic> json) {
    return ActionWorkflowResponse(
      total_count: json['total_count'] != null
          ? (json['total_count'] as num).toInt()
          : null,
      workflows: json['workflows'] != null
          ? (json['workflows'] as List<dynamic>)
                .map((e) => ActionWorkflow.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (total_count != null) map['total_count'] = total_count!;
    if (workflows != null)
      map['workflows'] = workflows!.map((e) => e.toJson()).toList();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionWorkflowResponse &&
          total_count == other.total_count &&
          workflows == other.workflows;
  @override
  int get hashCode => Object.hash(total_count, workflows);
  @override
  String toString() =>
      'ActionWorkflowResponse(total_count: $total_count, workflows: $workflows)';
}
