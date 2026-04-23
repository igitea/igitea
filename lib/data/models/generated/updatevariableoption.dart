part of 'generated_models.dart';

/// UpdateVariableOption the option when updating variable
class UpdateVariableOption {
  final String? description;
  final String? name;
  final String? value;
  const UpdateVariableOption({
    this.description,
    this.name,
    this.value,
  });
  factory UpdateVariableOption.fromJson(Map<String, dynamic> json) {
    return UpdateVariableOption(
      description: json['description'] != null ? json['description'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      value: json['value'] != null ? json['value'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (description != null) map['description'] = description!;
    if (name != null) map['name'] = name!;
    if (value != null) map['value'] = value!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateVariableOption &&
          description == other.description &&
          name == other.name &&
          value == other.value;
  @override
  int get hashCode => Object.hash(description, name, value);
  @override
  String toString() => 'UpdateVariableOption(description: $description, name: $name, value: $value)';
}
