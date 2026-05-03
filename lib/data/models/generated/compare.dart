part of 'generated_models.dart';

/// Compare represents a comparison between two commits.
class Compare {
  final List<Commit>? commits;
  final int? total_commits;
  const Compare({
    this.commits,
    this.total_commits,
  });
  factory Compare.fromJson(Map<String, dynamic> json) {
    return Compare(
      commits: json['commits'] != null ? (json['commits'] as List<dynamic>).map((e) => Commit.fromJson(e as Map<String, dynamic>)).toList() : null,
      total_commits: json['total_commits'] != null ? (json['total_commits'] as num).toInt() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (commits != null) map['commits'] = commits!.map((e) => e.toJson()).toList();
    if (total_commits != null) map['total_commits'] = total_commits!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Compare &&
          commits == other.commits &&
          total_commits == other.total_commits;
  @override
  int get hashCode => Object.hash(commits, total_commits);
  @override
  String toString() => 'Compare(commits: $commits, total_commits: $total_commits)';
}
