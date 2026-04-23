part of 'generated_models.dart';

/// GitBlobResponse represents a git blob
class GitBlobResponse {
  final String? content;
  final String? encoding;
  final String? lfs_oid;
  final int? lfs_size;
  final String? sha;
  final int? size;
  final String? url;
  const GitBlobResponse({
    this.content,
    this.encoding,
    this.lfs_oid,
    this.lfs_size,
    this.sha,
    this.size,
    this.url,
  });
  factory GitBlobResponse.fromJson(Map<String, dynamic> json) {
    return GitBlobResponse(
      content: json['content'] != null ? json['content'] as String : null,
      encoding: json['encoding'] != null ? json['encoding'] as String : null,
      lfs_oid: json['lfs_oid'] != null ? json['lfs_oid'] as String : null,
      lfs_size: json['lfs_size'] != null ? (json['lfs_size'] as num).toInt() : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
      size: json['size'] != null ? (json['size'] as num).toInt() : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (content != null) map['content'] = content!;
    if (encoding != null) map['encoding'] = encoding!;
    if (lfs_oid != null) map['lfs_oid'] = lfs_oid!;
    if (lfs_size != null) map['lfs_size'] = lfs_size!;
    if (sha != null) map['sha'] = sha!;
    if (size != null) map['size'] = size!;
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitBlobResponse &&
          content == other.content &&
          encoding == other.encoding &&
          lfs_oid == other.lfs_oid &&
          lfs_size == other.lfs_size &&
          sha == other.sha &&
          size == other.size &&
          url == other.url;
  @override
  int get hashCode => Object.hash(content, encoding, lfs_oid, lfs_size, sha, size, url);
  @override
  String toString() => 'GitBlobResponse(content: $content, encoding: $encoding, lfs_oid: $lfs_oid, lfs_size: $lfs_size, sha: $sha, size: $size, url: $url)';
}
