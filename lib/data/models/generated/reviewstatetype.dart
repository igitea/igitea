part of 'generated_models.dart';

/// ReviewStateType review state type
class ReviewStateType {
  final String? value;
  const ReviewStateType({this.value});
  factory ReviewStateType.fromJson(dynamic json) {
    if (json is String) {
      return ReviewStateType(value: json);
    }
    if (json is Map<String, dynamic>) {
      return ReviewStateType();
    }
    return ReviewStateType();
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (value != null) map['value'] = value!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewStateType && value == other.value;
  @override
  int get hashCode => value.hashCode;
  @override
  String toString() => 'ReviewStateType(value: $value)';
}
