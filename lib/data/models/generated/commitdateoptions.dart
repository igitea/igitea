part of 'generated_models.dart';

/// CommitDateOptions store dates for GIT_AUTHOR_DATE and GIT_COMMITTER_DATE
class CommitDateOptions {
  final DateTime? author;
  final DateTime? committer;
  const CommitDateOptions({
    this.author,
    this.committer,
  });
  factory CommitDateOptions.fromJson(Map<String, dynamic> json) {
    return CommitDateOptions(
      author: json['author'] != null ? DateTime.parse(json['author'] as String) : null,
      committer: json['committer'] != null ? DateTime.parse(json['committer'] as String) : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (author != null) map['author'] = author!.toIso8601String();
    if (committer != null) map['committer'] = committer!.toIso8601String();
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommitDateOptions &&
          author == other.author &&
          committer == other.committer;
  @override
  int get hashCode => Object.hash(author, committer);
  @override
  String toString() => 'CommitDateOptions(author: $author, committer: $committer)';
}
