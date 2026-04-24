part of 'generated_models.dart';

/// AnnotatedTagObject contains meta information of the tag object
class AnnotatedTagObject {
  final String? sha;
  final String? type;
  final String? url;
  const AnnotatedTagObject({this.sha, this.type, this.url});
  factory AnnotatedTagObject.fromJson(Map<String, dynamic> json) {
    return AnnotatedTagObject(
      sha: json['sha'] != null ? json['sha'] as String : null,
      type: json['type'] != null ? json['type'] as String : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (sha != null) map['sha'] = sha!;
    if (type != null) map['type'] = type!;
    if (url != null) map['url'] = url!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnotatedTagObject &&
          sha == other.sha &&
          type == other.type &&
          url == other.url;
  @override
  int get hashCode => Object.hash(sha, type, url);
  @override
  String toString() => 'AnnotatedTagObject(sha: $sha, type: $type, url: $url)';
}
