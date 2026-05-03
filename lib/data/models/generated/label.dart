part of 'generated_models.dart';

/// Label a label to an issue or a pr
class Label {
  final String? color;
  final String? description;
  final bool? exclusive;
  final int? id;
  final bool? is_archived;
  final String? name;
  final String? url;
  const Label({
    this.color,
    this.description,
    this.exclusive,
    this.id,
    this.is_archived,
    this.name,
    this.url,
  });
  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      color: json['color'] != null ? json['color'] as String : null,
      description: json['description'] != null ? json['description'] as String : null,
      exclusive: json['exclusive'] != null ? json['exclusive'] as bool : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      is_archived: json['is_archived'] != null ? json['is_archived'] as bool : null,
      name: json['name'] != null ? json['name'] as String : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (color != null) map['color'] = color!;
    if (description != null) map['description'] = description!;
    if (exclusive != null) map['exclusive'] = exclusive!;
    if (id != null) map['id'] = id!;
    if (is_archived != null) map['is_archived'] = is_archived!;
    if (name != null) map['name'] = name!;
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Label &&
          color == other.color &&
          description == other.description &&
          exclusive == other.exclusive &&
          id == other.id &&
          is_archived == other.is_archived &&
          name == other.name &&
          url == other.url;
  @override
  int get hashCode => Object.hash(color, description, exclusive, id, is_archived, name, url);
  @override
  String toString() => 'Label(color: $color, description: $description, exclusive: $exclusive, id: $id, is_archived: $is_archived, name: $name, url: $url)';
}
