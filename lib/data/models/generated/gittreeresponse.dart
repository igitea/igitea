part of 'generated_models.dart';

/// GitTreeResponse returns a git tree
class GitTreeResponse {
  final int? page;
  final String? sha;
  final int? total_count;
  final List<GitEntry>? tree;
  final bool? truncated;
  final String? url;
  const GitTreeResponse({
    this.page,
    this.sha,
    this.total_count,
    this.tree,
    this.truncated,
    this.url,
  });
  factory GitTreeResponse.fromJson(Map<String, dynamic> json) {
    return GitTreeResponse(
      page: json['page'] != null ? (json['page'] as num).toInt() : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
      total_count: json['total_count'] != null ? (json['total_count'] as num).toInt() : null,
      tree: json['tree'] != null ? (json['tree'] as List<dynamic>).map((e) => GitEntry.fromJson(e as Map<String, dynamic>)).toList() : null,
      truncated: json['truncated'] != null ? json['truncated'] as bool : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (page != null) map['page'] = page!;
    if (sha != null) map['sha'] = sha!;
    if (total_count != null) map['total_count'] = total_count!;
    if (tree != null) map['tree'] = tree!.map((e) => e.toJson()).toList();
    if (truncated != null) map['truncated'] = truncated!;
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitTreeResponse &&
          page == other.page &&
          sha == other.sha &&
          total_count == other.total_count &&
          tree == other.tree &&
          truncated == other.truncated &&
          url == other.url;
  @override
  int get hashCode => Object.hash(page, sha, total_count, tree, truncated, url);
  @override
  String toString() => 'GitTreeResponse(page: $page, sha: $sha, total_count: $total_count, tree: $tree, truncated: $truncated, url: $url)';
}
