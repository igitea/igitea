part of 'generated_models.dart';

/// CommitMeta contains meta information of a commit in terms of API.
class CommitMeta {
  final DateTime? created;
  final String? sha;
  final String? url;
  const CommitMeta({
    this.created,
    this.sha,
    this.url,
  });
  factory CommitMeta.fromJson(Map<String, dynamic> json) {
    return CommitMeta(
      created: json['created'] != null ? DateTime.parse(json['created'] as String) : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created != null) map['created'] = created!.toIso8601String();
    if (sha != null) map['sha'] = sha!;
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommitMeta &&
          created == other.created &&
          sha == other.sha &&
          url == other.url;
  @override
  int get hashCode => Object.hash(created, sha, url);
  @override
  String toString() => 'CommitMeta(created: $created, sha: $sha, url: $url)';
}
