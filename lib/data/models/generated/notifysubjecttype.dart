part of 'generated_models.dart';

/// NotifySubjectType represent type of notification subject
class NotifySubjectType {
  final String? value;
  const NotifySubjectType({this.value});
  factory NotifySubjectType.fromJson(dynamic json) {
    if (json is String) {
      return NotifySubjectType(value: json);
    }
    if (json is Map<String, dynamic>) {
      return NotifySubjectType();
    }
    return NotifySubjectType();
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (value != null) map['value'] = value!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotifySubjectType && value == other.value;
  @override
  int get hashCode => value.hashCode;
  @override
  String toString() => 'NotifySubjectType(value: $value)';
}
