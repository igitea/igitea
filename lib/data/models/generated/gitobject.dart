part of 'generated_models.dart';

/// GitObject represents a Git object.
class GitObject {
  final String? sha;
  final String? type;
  final String? url;
  const GitObject({this.sha, this.type, this.url});
  factory GitObject.fromJson(Map<String, dynamic> json) {
    return GitObject(
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
      other is GitObject &&
          sha == other.sha &&
          type == other.type &&
          url == other.url;
  @override
  int get hashCode => Object.hash(sha, type, url);
  @override
  String toString() => 'GitObject(sha: $sha, type: $type, url: $url)';
}
