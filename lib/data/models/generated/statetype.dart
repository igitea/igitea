part of 'generated_models.dart';

/// StateType issue state type
class StateType {
  final String? value;
  const StateType({this.value});
  factory StateType.fromJson(dynamic json) {
    if (json is String) {
      return StateType(value: json);
    }
    if (json is Map<String, dynamic>) {
      return StateType();
    }
    return StateType();
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (value != null) map['value'] = value!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateType && value == other.value;
  @override
  int get hashCode => value.hashCode;
  @override
  String toString() => 'StateType(value: $value)';
}
