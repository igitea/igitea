part of 'generated_models.dart';

/// Reference represents a Git reference.
class Reference {
  final GitObject? object;
  final String? ref;
  final String? url;
  const Reference({
    this.object,
    this.ref,
    this.url,
  });
  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      object: json['object'] != null ? GitObject.fromJson(json['object'] as Map<String, dynamic>) : null,
      ref: json['ref'] != null ? json['ref'] as String : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (object != null) map['object'] = object!.toJson();
    if (ref != null) map['ref'] = ref!;
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reference &&
          object == other.object &&
          ref == other.ref &&
          url == other.url;
  @override
  int get hashCode => Object.hash(object, ref, url);
  @override
  String toString() => 'Reference(object: $object, ref: $ref, url: $url)';
}
