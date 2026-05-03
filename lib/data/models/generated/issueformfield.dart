part of 'generated_models.dart';

/// IssueFormField represents a form field
class IssueFormField {
  final Map<String, dynamic>? attributes;
  final String? id;
  final IssueFormFieldType? type;
  final Map<String, dynamic>? validations;
  final List<IssueFormFieldVisible>? visible;
  const IssueFormField({
    this.attributes,
    this.id,
    this.type,
    this.validations,
    this.visible,
  });
  factory IssueFormField.fromJson(Map<String, dynamic> json) {
    return IssueFormField(
      attributes: json['attributes'] != null ? json['attributes'] as Map<String, dynamic> : null,
      id: json['id'] != null ? json['id'] as String : null,
      type: json['type'] != null ? IssueFormFieldType.fromJson(json['type']) : null,
      validations: json['validations'] != null ? json['validations'] as Map<String, dynamic> : null,
      visible: json['visible'] != null ? (json['visible'] as List<dynamic>).map((e) => IssueFormFieldVisible.fromJson(e)).toList() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (attributes != null) map['attributes'] = attributes!;
    if (id != null) map['id'] = id!;
    if (type != null) map['type'] = type!.toJson();
    if (validations != null) map['validations'] = validations!;
    if (visible != null) map['visible'] = visible!.map((e) => e.toJson()).toList();
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueFormField &&
          attributes == other.attributes &&
          id == other.id &&
          type == other.type &&
          validations == other.validations &&
          visible == other.visible;
  @override
  int get hashCode => Object.hash(attributes, id, type, validations, visible);
  @override
  String toString() => 'IssueFormField(attributes: $attributes, id: $id, type: $type, validations: $validations, visible: $visible)';
}
