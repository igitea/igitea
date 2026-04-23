part of 'generated_models.dart';

/// ActionRunner represents a Runner
class ActionRunner {
  final bool? busy;
  final bool? ephemeral;
  final int? id;
  final List<ActionRunnerLabel>? labels;
  final String? name;
  final String? status;
  const ActionRunner({
    this.busy,
    this.ephemeral,
    this.id,
    this.labels,
    this.name,
    this.status,
  });
  factory ActionRunner.fromJson(Map<String, dynamic> json) {
    return ActionRunner(
      busy: json['busy'] != null ? json['busy'] as bool : null,
      ephemeral: json['ephemeral'] != null ? json['ephemeral'] as bool : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      labels: json['labels'] != null ? (json['labels'] as List<dynamic>).map((e) => ActionRunnerLabel.fromJson(e as Map<String, dynamic>)).toList() : null,
      name: json['name'] != null ? json['name'] as String : null,
      status: json['status'] != null ? json['status'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (busy != null) map['busy'] = busy!;
    if (ephemeral != null) map['ephemeral'] = ephemeral!;
    if (id != null) map['id'] = id!;
    if (labels != null) map['labels'] = labels!.map((e) => e.toJson()).toList();
    if (name != null) map['name'] = name!;
    if (status != null) map['status'] = status!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionRunner &&
          busy == other.busy &&
          ephemeral == other.ephemeral &&
          id == other.id &&
          labels == other.labels &&
          name == other.name &&
          status == other.status;
  @override
  int get hashCode => Object.hash(busy, ephemeral, id, labels, name, status);
  @override
  String toString() => 'ActionRunner(busy: $busy, ephemeral: $ephemeral, id: $id, labels: $labels, name: $name, status: $status)';
}
