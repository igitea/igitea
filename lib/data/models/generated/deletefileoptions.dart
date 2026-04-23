part of 'generated_models.dart';

/// DeleteFileOptions options for deleting files (used for other File structs below) Note: `author` and `committer` are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)
class DeleteFileOptions {
  final Identity? author;
  final String? branch;
  final Identity? committer;
  final CommitDateOptions? dates;
  final String? message;
  final String? new_branch;
  final String? sha;
  final bool? signoff;
  const DeleteFileOptions({
    this.author,
    this.branch,
    this.committer,
    this.dates,
    this.message,
    this.new_branch,
    this.sha,
    this.signoff,
  });
  factory DeleteFileOptions.fromJson(Map<String, dynamic> json) {
    return DeleteFileOptions(
      author: json['author'] != null ? Identity.fromJson(json['author'] as Map<String, dynamic>) : null,
      branch: json['branch'] != null ? json['branch'] as String : null,
      committer: json['committer'] != null ? Identity.fromJson(json['committer'] as Map<String, dynamic>) : null,
      dates: json['dates'] != null ? CommitDateOptions.fromJson(json['dates'] as Map<String, dynamic>) : null,
      message: json['message'] != null ? json['message'] as String : null,
      new_branch: json['new_branch'] != null ? json['new_branch'] as String : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
      signoff: json['signoff'] != null ? json['signoff'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (author != null) map['author'] = author!.toJson();
    if (branch != null) map['branch'] = branch!;
    if (committer != null) map['committer'] = committer!.toJson();
    if (dates != null) map['dates'] = dates!.toJson();
    if (message != null) map['message'] = message!;
    if (new_branch != null) map['new_branch'] = new_branch!;
    if (sha != null) map['sha'] = sha!;
    if (signoff != null) map['signoff'] = signoff!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteFileOptions &&
          author == other.author &&
          branch == other.branch &&
          committer == other.committer &&
          dates == other.dates &&
          message == other.message &&
          new_branch == other.new_branch &&
          sha == other.sha &&
          signoff == other.signoff;
  @override
  int get hashCode => Object.hash(author, branch, committer, dates, message, new_branch, sha, signoff);
  @override
  String toString() => 'DeleteFileOptions(author: $author, branch: $branch, committer: $committer, dates: $dates, message: $message, new_branch: $new_branch, sha: $sha, signoff: $signoff)';
}
