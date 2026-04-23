part of 'generated_models.dart';

/// FileCommitResponse contains information generated from a Git commit for a repo's file.
class FileCommitResponse {
  final CommitUser? author;
  final CommitUser? committer;
  final DateTime? created;
  final String? html_url;
  final String? message;
  final List<CommitMeta>? parents;
  final String? sha;
  final CommitMeta? tree;
  final String? url;
  const FileCommitResponse({
    this.author,
    this.committer,
    this.created,
    this.html_url,
    this.message,
    this.parents,
    this.sha,
    this.tree,
    this.url,
  });
  factory FileCommitResponse.fromJson(Map<String, dynamic> json) {
    return FileCommitResponse(
      author: json['author'] != null ? CommitUser.fromJson(json['author'] as Map<String, dynamic>) : null,
      committer: json['committer'] != null ? CommitUser.fromJson(json['committer'] as Map<String, dynamic>) : null,
      created: json['created'] != null ? DateTime.parse(json['created'] as String) : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      message: json['message'] != null ? json['message'] as String : null,
      parents: json['parents'] != null ? (json['parents'] as List<dynamic>).map((e) => CommitMeta.fromJson(e as Map<String, dynamic>)).toList() : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
      tree: json['tree'] != null ? CommitMeta.fromJson(json['tree'] as Map<String, dynamic>) : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (author != null) map['author'] = author!.toJson();
    if (committer != null) map['committer'] = committer!.toJson();
    if (created != null) map['created'] = created!.toIso8601String();
    if (html_url != null) map['html_url'] = html_url!;
    if (message != null) map['message'] = message!;
    if (parents != null) map['parents'] = parents!.map((e) => e.toJson()).toList();
    if (sha != null) map['sha'] = sha!;
    if (tree != null) map['tree'] = tree!.toJson();
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileCommitResponse &&
          author == other.author &&
          committer == other.committer &&
          created == other.created &&
          html_url == other.html_url &&
          message == other.message &&
          parents == other.parents &&
          sha == other.sha &&
          tree == other.tree &&
          url == other.url;
  @override
  int get hashCode => Object.hash(author, committer, created, html_url, message, parents, sha, tree, url);
  @override
  String toString() => 'FileCommitResponse(author: $author, committer: $committer, created: $created, html_url: $html_url, message: $message, parents: $parents, sha: $sha, tree: $tree, url: $url)';
}
