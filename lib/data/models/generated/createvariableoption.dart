part of 'generated_models.dart';

/// CreateVariableOption the option when creating variable
class CreateVariableOption {
  final String? description;
  final String? value;
  const CreateVariableOption({this.description, this.value});
  factory CreateVariableOption.fromJson(Map<String, dynamic> json) {
    return CreateVariableOption(
      description: json['description'] != null
          ? json['description'] as String
          : null,
      value: json['value'] != null ? json['value'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (description != null) map['description'] = description!;
    if (value != null) map['value'] = value!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateVariableOption &&
          description == other.description &&
          value == other.value;
  @override
  int get hashCode => Object.hash(description, value);
  @override
  String toString() =>
      'CreateVariableOption(description: $description, value: $value)';
}
