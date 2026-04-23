part of 'generated_models.dart';

/// CommitStats is statistics for a RepoCommit
class CommitStats {
  final int? additions;
  final int? deletions;
  final int? total;
  const CommitStats({
    this.additions,
    this.deletions,
    this.total,
  });
  factory CommitStats.fromJson(Map<String, dynamic> json) {
    return CommitStats(
      additions: json['additions'] != null ? (json['additions'] as num).toInt() : null,
      deletions: json['deletions'] != null ? (json['deletions'] as num).toInt() : null,
      total: json['total'] != null ? (json['total'] as num).toInt() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (additions != null) map['additions'] = additions!;
    if (deletions != null) map['deletions'] = deletions!;
    if (total != null) map['total'] = total!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommitStats &&
          additions == other.additions &&
          deletions == other.deletions &&
          total == other.total;
  @override
  int get hashCode => Object.hash(additions, deletions, total);
  @override
  String toString() => 'CommitStats(additions: $additions, deletions: $deletions, total: $total)';
}
