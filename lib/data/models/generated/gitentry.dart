part of 'generated_models.dart';

/// GitEntry represents a git tree
class GitEntry {
  final String? mode;
  final String? path;
  final String? sha;
  final int? size;
  final String? type;
  final String? url;
  const GitEntry({
    this.mode,
    this.path,
    this.sha,
    this.size,
    this.type,
    this.url,
  });
  factory GitEntry.fromJson(Map<String, dynamic> json) {
    return GitEntry(
      mode: json['mode'] != null ? json['mode'] as String : null,
      path: json['path'] != null ? json['path'] as String : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
      size: json['size'] != null ? (json['size'] as num).toInt() : null,
      type: json['type'] != null ? json['type'] as String : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (mode != null) map['mode'] = mode!;
    if (path != null) map['path'] = path!;
    if (sha != null) map['sha'] = sha!;
    if (size != null) map['size'] = size!;
    if (type != null) map['type'] = type!;
    if (url != null) map['url'] = url!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitEntry &&
          mode == other.mode &&
          path == other.path &&
          sha == other.sha &&
          size == other.size &&
          type == other.type &&
          url == other.url;
  @override
  int get hashCode => Object.hash(mode, path, sha, size, type, url);
  @override
  String toString() =>
      'GitEntry(mode: $mode, path: $path, sha: $sha, size: $size, type: $type, url: $url)';
}
