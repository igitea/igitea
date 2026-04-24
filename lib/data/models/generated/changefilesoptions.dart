part of 'generated_models.dart';

/// ChangeFilesOptions options for creating, updating or deleting multiple files Note: `author` and `committer` are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)
class ChangeFilesOptions {
  final Identity? author;
  final String? branch;
  final Identity? committer;
  final CommitDateOptions? dates;
  final List<ChangeFileOperation>? files;
  final String? message;
  final String? new_branch;
  final bool? signoff;
  const ChangeFilesOptions({
    this.author,
    this.branch,
    this.committer,
    this.dates,
    this.files,
    this.message,
    this.new_branch,
    this.signoff,
  });
  factory ChangeFilesOptions.fromJson(Map<String, dynamic> json) {
    return ChangeFilesOptions(
      author: json['author'] != null
          ? Identity.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      branch: json['branch'] != null ? json['branch'] as String : null,
      committer: json['committer'] != null
          ? Identity.fromJson(json['committer'] as Map<String, dynamic>)
          : null,
      dates: json['dates'] != null
          ? CommitDateOptions.fromJson(json['dates'] as Map<String, dynamic>)
          : null,
      files: json['files'] != null
          ? (json['files'] as List<dynamic>)
                .map(
                  (e) =>
                      ChangeFileOperation.fromJson(e as Map<String, dynamic>),
                )
                .toList()
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
    if (dates != null) map['dates'] = dates!.toJson();
    if (files != null) map['files'] = files!.map((e) => e.toJson()).toList();
    if (message != null) map['message'] = message!;
    if (new_branch != null) map['new_branch'] = new_branch!;
    if (signoff != null) map['signoff'] = signoff!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangeFilesOptions &&
          author == other.author &&
          branch == other.branch &&
          committer == other.committer &&
          dates == other.dates &&
          files == other.files &&
          message == other.message &&
          new_branch == other.new_branch &&
          signoff == other.signoff;
  @override
  int get hashCode => Object.hash(
    author,
    branch,
    committer,
    dates,
    files,
    message,
    new_branch,
    signoff,
  );
  @override
  String toString() =>
      'ChangeFilesOptions(author: $author, branch: $branch, committer: $committer, dates: $dates, files: $files, message: $message, new_branch: $new_branch, signoff: $signoff)';
}
