part of 'generated_models.dart';

/// IssueFormFieldType defines issue form field type, can be "markdown", "textarea", "input", "dropdown" or "checkboxes"
class IssueFormFieldType {
  const IssueFormFieldType();
  factory IssueFormFieldType.fromJson(Map<String, dynamic> json) {
    return IssueFormFieldType();
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    return map;
  }

  @override
  bool operator ==(Object other) => identical(this, other);
  @override
  int get hashCode => 0;
  @override
  String toString() => 'IssueFormFieldType()';
}
