part of 'generated_models.dart';

/// ActionRunnerLabel represents a Runner Label
class ActionRunnerLabel {
  final int? id;
  final String? name;
  final String? type;
  const ActionRunnerLabel({
    this.id,
    this.name,
    this.type,
  });
  factory ActionRunnerLabel.fromJson(Map<String, dynamic> json) {
    return ActionRunnerLabel(
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      name: json['name'] != null ? json['name'] as String : null,
      type: json['type'] != null ? json['type'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id!;
    if (name != null) map['name'] = name!;
    if (type != null) map['type'] = type!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionRunnerLabel &&
          id == other.id &&
          name == other.name &&
          type == other.type;
  @override
  int get hashCode => Object.hash(id, name, type);
  @override
  String toString() => 'ActionRunnerLabel(id: $id, name: $name, type: $type)';
}
