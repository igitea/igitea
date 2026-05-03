part of 'generated_models.dart';

/// IssueFormFieldVisible defines issue form field visible
class IssueFormFieldVisible {
  final String? value;
  const IssueFormFieldVisible({this.value});
  factory IssueFormFieldVisible.fromJson(dynamic json) {
    if (json is String) {
      return IssueFormFieldVisible(value: json);
    }
    if (json is Map<String, dynamic>) {
      return IssueFormFieldVisible();
    }
    return IssueFormFieldVisible();
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (value != null) map['value'] = value!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueFormFieldVisible && value == other.value;
  @override
  int get hashCode => value.hashCode;
  @override
  String toString() => 'IssueFormFieldVisible(value: $value)';
}
