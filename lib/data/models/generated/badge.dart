part of 'generated_models.dart';

/// Badge represents a user badge
class Badge {
  final String? description;
  final int? id;
  final String? image_url;
  final String? slug;
  const Badge({this.description, this.id, this.image_url, this.slug});
  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      description: json['description'] != null
          ? json['description'] as String
          : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      image_url: json['image_url'] != null ? json['image_url'] as String : null,
      slug: json['slug'] != null ? json['slug'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (description != null) map['description'] = description!;
    if (id != null) map['id'] = id!;
    if (image_url != null) map['image_url'] = image_url!;
    if (slug != null) map['slug'] = slug!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Badge &&
          description == other.description &&
          id == other.id &&
          image_url == other.image_url &&
          slug == other.slug;
  @override
  int get hashCode => Object.hash(description, id, image_url, slug);
  @override
  String toString() =>
      'Badge(description: $description, id: $id, image_url: $image_url, slug: $slug)';
}
