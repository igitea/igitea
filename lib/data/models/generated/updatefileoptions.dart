part of 'generated_models.dart';

/// UpdateFileOptions options for updating files Note: `author` and `committer` are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)
class UpdateFileOptions {
  final Identity? author;
  final String? branch;
  final Identity? committer;
  final String? content;
  final CommitDateOptions? dates;
  final String? from_path;
  final String? message;
  final String? new_branch;
  final String? sha;
  final bool? signoff;
  const UpdateFileOptions({
    this.author,
    this.branch,
    this.committer,
    this.content,
    this.dates,
    this.from_path,
    this.message,
    this.new_branch,
    this.sha,
    this.signoff,
  });
  factory UpdateFileOptions.fromJson(Map<String, dynamic> json) {
    return UpdateFileOptions(
      author: json['author'] != null
          ? Identity.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      branch: json['branch'] != null ? json['branch'] as String : null,
      committer: json['committer'] != null
          ? Identity.fromJson(json['committer'] as Map<String, dynamic>)
          : null,
      content: json['content'] != null ? json['content'] as String : null,
      dates: json['dates'] != null
          ? CommitDateOptions.fromJson(json['dates'] as Map<String, dynamic>)
          : null,
      from_path: json['from_path'] != null ? json['from_path'] as String : null,
      message: json['message'] != null ? json['message'] as String : null,
      new_branch: json['new_branch'] != null
          ? json['new_branch'] as String
          : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
      signoff: json['signoff'] != null ? json['signoff'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (author != null) map['author'] = author!.toJson();
    if (branch != null) map['branch'] = branch!;
    if (committer != null) map['committer'] = committer!.toJson();
    if (content != null) map['content'] = content!;
    if (dates != null) map['dates'] = dates!.toJson();
    if (from_path != null) map['from_path'] = from_path!;
    if (message != null) map['message'] = message!;
    if (new_branch != null) map['new_branch'] = new_branch!;
    if (sha != null) map['sha'] = sha!;
    if (signoff != null) map['signoff'] = signoff!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateFileOptions &&
          author == other.author &&
          branch == other.branch &&
          committer == other.committer &&
          content == other.content &&
          dates == other.dates &&
          from_path == other.from_path &&
          message == other.message &&
          new_branch == other.new_branch &&
          sha == other.sha &&
          signoff == other.signoff;
  @override
  int get hashCode => Object.hash(
    author,
    branch,
    committer,
    content,
    dates,
    from_path,
    message,
    new_branch,
    sha,
    signoff,
  );
  @override
  String toString() =>
      'UpdateFileOptions(author: $author, branch: $branch, committer: $committer, content: $content, dates: $dates, from_path: $from_path, message: $message, new_branch: $new_branch, sha: $sha, signoff: $signoff)';
}
