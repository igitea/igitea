part of 'generated_models.dart';

/// CreateLabelOption options for creating a label
class CreateLabelOption {
  final String? color;
  final String? description;
  final bool? exclusive;
  final bool? is_archived;
  final String? name;
  const CreateLabelOption({
    this.color,
    this.description,
    this.exclusive,
    this.is_archived,
    this.name,
  });
  factory CreateLabelOption.fromJson(Map<String, dynamic> json) {
    return CreateLabelOption(
      color: json['color'] != null ? json['color'] as String : null,
      description: json['description'] != null
          ? json['description'] as String
          : null,
      exclusive: json['exclusive'] != null ? json['exclusive'] as bool : null,
      is_archived: json['is_archived'] != null
          ? json['is_archived'] as bool
          : null,
      name: json['name'] != null ? json['name'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (color != null) map['color'] = color!;
    if (description != null) map['description'] = description!;
    if (exclusive != null) map['exclusive'] = exclusive!;
    if (is_archived != null) map['is_archived'] = is_archived!;
    if (name != null) map['name'] = name!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateLabelOption &&
          color == other.color &&
          description == other.description &&
          exclusive == other.exclusive &&
          is_archived == other.is_archived &&
          name == other.name;
  @override
  int get hashCode =>
      Object.hash(color, description, exclusive, is_archived, name);
  @override
  String toString() =>
      'CreateLabelOption(color: $color, description: $description, exclusive: $exclusive, is_archived: $is_archived, name: $name)';
}
