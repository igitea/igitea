part of 'generated_models.dart';

/// WikiCommit page commit/revision
class WikiCommit {
  final CommitUser? author;
  final CommitUser? commiter;
  final String? message;
  final String? sha;
  const WikiCommit({
    this.author,
    this.commiter,
    this.message,
    this.sha,
  });
  factory WikiCommit.fromJson(Map<String, dynamic> json) {
    return WikiCommit(
      author: json['author'] != null ? CommitUser.fromJson(json['author'] as Map<String, dynamic>) : null,
      commiter: json['commiter'] != null ? CommitUser.fromJson(json['commiter'] as Map<String, dynamic>) : null,
      message: json['message'] != null ? json['message'] as String : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (author != null) map['author'] = author!.toJson();
    if (commiter != null) map['commiter'] = commiter!.toJson();
    if (message != null) map['message'] = message!;
    if (sha != null) map['sha'] = sha!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WikiCommit &&
          author == other.author &&
          commiter == other.commiter &&
          message == other.message &&
          sha == other.sha;
  @override
  int get hashCode => Object.hash(author, commiter, message, sha);
  @override
  String toString() => 'WikiCommit(author: $author, commiter: $commiter, message: $message, sha: $sha)';
}
