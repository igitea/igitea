part of 'generated_models.dart';

/// CreateFileOptions options for creating files Note: `author` and `committer` are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)
class CreateFileOptions {
  final Identity? author;
  final String? branch;
  final Identity? committer;
  final String? content;
  final CommitDateOptions? dates;
  final String? message;
  final String? new_branch;
  final bool? signoff;
  const CreateFileOptions({
    this.author,
    this.branch,
    this.committer,
    this.content,
    this.dates,
    this.message,
    this.new_branch,
    this.signoff,
  });
  factory CreateFileOptions.fromJson(Map<String, dynamic> json) {
    return CreateFileOptions(
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
      message: json['message'] != null ? json['message'] as String : null,
      new_branch: json['new_branch'] != null
          ? json['new_branch'] as String
          : null,
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
    if (message != null) map['message'] = message!;
    if (new_branch != null) map['new_branch'] = new_branch!;
    if (signoff != null) map['signoff'] = signoff!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateFileOptions &&
          author == other.author &&
          branch == other.branch &&
          committer == other.committer &&
          content == other.content &&
          dates == other.dates &&
          message == other.message &&
          new_branch == other.new_branch &&
          signoff == other.signoff;
  @override
  int get hashCode => Object.hash(
    author,
    branch,
    committer,
    content,
    dates,
    message,
    new_branch,
    signoff,
  );
  @override
  String toString() =>
      'CreateFileOptions(author: $author, branch: $branch, committer: $committer, content: $content, dates: $dates, message: $message, new_branch: $new_branch, signoff: $signoff)';
}
