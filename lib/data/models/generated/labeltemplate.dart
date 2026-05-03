part of 'generated_models.dart';

/// LabelTemplate info of a Label template
class LabelTemplate {
  final String? color;
  final String? description;
  final bool? exclusive;
  final String? name;
  const LabelTemplate({
    this.color,
    this.description,
    this.exclusive,
    this.name,
  });
  factory LabelTemplate.fromJson(Map<String, dynamic> json) {
    return LabelTemplate(
      color: json['color'] != null ? json['color'] as String : null,
      description: json['description'] != null ? json['description'] as String : null,
      exclusive: json['exclusive'] != null ? json['exclusive'] as bool : null,
      name: json['name'] != null ? json['name'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (color != null) map['color'] = color!;
    if (description != null) map['description'] = description!;
    if (exclusive != null) map['exclusive'] = exclusive!;
    if (name != null) map['name'] = name!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabelTemplate &&
          color == other.color &&
          description == other.description &&
          exclusive == other.exclusive &&
          name == other.name;
  @override
  int get hashCode => Object.hash(color, description, exclusive, name);
  @override
  String toString() => 'LabelTemplate(color: $color, description: $description, exclusive: $exclusive, name: $name)';
}
