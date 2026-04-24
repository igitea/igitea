part of 'generated_models.dart';

/// CreateActionWorkflowDispatch represents the payload for triggering a workflow dispatch event
class CreateActionWorkflowDispatch {
  final Map<String, dynamic>? inputs;
  final String? ref;
  const CreateActionWorkflowDispatch({this.inputs, this.ref});
  factory CreateActionWorkflowDispatch.fromJson(Map<String, dynamic> json) {
    return CreateActionWorkflowDispatch(
      inputs: json['inputs'] != null
          ? json['inputs'] as Map<String, dynamic>
          : null,
      ref: json['ref'] != null ? json['ref'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (inputs != null) map['inputs'] = inputs!;
    if (ref != null) map['ref'] = ref!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateActionWorkflowDispatch &&
          inputs == other.inputs &&
          ref == other.ref;
  @override
  int get hashCode => Object.hash(inputs, ref);
  @override
  String toString() =>
      'CreateActionWorkflowDispatch(inputs: $inputs, ref: $ref)';
}
