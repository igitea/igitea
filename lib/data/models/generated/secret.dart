part of 'generated_models.dart';

/// Secret represents a secret
class Secret {
  final DateTime? created_at;
  final String? description;
  final String? name;
  const Secret({this.created_at, this.description, this.name});
  factory Secret.fromJson(Map<String, dynamic> json) {
    return Secret(
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      description: json['description'] != null
          ? json['description'] as String
          : null,
      name: json['name'] != null ? json['name'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (description != null) map['description'] = description!;
    if (name != null) map['name'] = name!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Secret &&
          created_at == other.created_at &&
          description == other.description &&
          name == other.name;
  @override
  int get hashCode => Object.hash(created_at, description, name);
  @override
  String toString() =>
      'Secret(created_at: $created_at, description: $description, name: $name)';
}
