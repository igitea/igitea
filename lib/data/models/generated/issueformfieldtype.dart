part of 'generated_models.dart';

/// IssueFormFieldType defines issue form field type, can be "markdown", "textarea", "input", "dropdown" or "checkboxes"
class IssueFormFieldType {
  final String? value;
  const IssueFormFieldType({this.value});
  factory IssueFormFieldType.fromJson(dynamic json) {
    if (json is String) {
      return IssueFormFieldType(value: json);
    }
    if (json is Map<String, dynamic>) {
      return IssueFormFieldType();
    }
    return IssueFormFieldType();
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (value != null) map['value'] = value!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueFormFieldType && value == other.value;
  @override
  int get hashCode => value.hashCode;
  @override
  String toString() => 'IssueFormFieldType(value: $value)';
}
