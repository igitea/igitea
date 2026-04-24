part of 'generated_models.dart';

/// RepoCommit contains information of a commit in the context of a repository.
class RepoCommit {
  final CommitUser? author;
  final CommitUser? committer;
  final String? message;
  final CommitMeta? tree;
  final String? url;
  final PayloadCommitVerification? verification;
  const RepoCommit({
    this.author,
    this.committer,
    this.message,
    this.tree,
    this.url,
    this.verification,
  });
  factory RepoCommit.fromJson(Map<String, dynamic> json) {
    return RepoCommit(
      author: json['author'] != null
          ? CommitUser.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      committer: json['committer'] != null
          ? CommitUser.fromJson(json['committer'] as Map<String, dynamic>)
          : null,
      message: json['message'] != null ? json['message'] as String : null,
      tree: json['tree'] != null
          ? CommitMeta.fromJson(json['tree'] as Map<String, dynamic>)
          : null,
      url: json['url'] != null ? json['url'] as String : null,
      verification: json['verification'] != null
          ? PayloadCommitVerification.fromJson(
              json['verification'] as Map<String, dynamic>,
            )
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (author != null) map['author'] = author!.toJson();
    if (committer != null) map['committer'] = committer!.toJson();
    if (message != null) map['message'] = message!;
    if (tree != null) map['tree'] = tree!.toJson();
    if (url != null) map['url'] = url!;
    if (verification != null) map['verification'] = verification!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepoCommit &&
          author == other.author &&
          committer == other.committer &&
          message == other.message &&
          tree == other.tree &&
          url == other.url &&
          verification == other.verification;
  @override
  int get hashCode =>
      Object.hash(author, committer, message, tree, url, verification);
  @override
  String toString() =>
      'RepoCommit(author: $author, committer: $committer, message: $message, tree: $tree, url: $url, verification: $verification)';
}
