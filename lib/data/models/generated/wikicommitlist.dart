part of 'generated_models.dart';

/// WikiCommitList commit/revision list
class WikiCommitList {
  final List<WikiCommit>? commits;
  final int? count;
  const WikiCommitList({this.commits, this.count});
  factory WikiCommitList.fromJson(Map<String, dynamic> json) {
    return WikiCommitList(
      commits: json['commits'] != null
          ? (json['commits'] as List<dynamic>)
                .map((e) => WikiCommit.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      count: json['count'] != null ? (json['count'] as num).toInt() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (commits != null)
      map['commits'] = commits!.map((e) => e.toJson()).toList();
    if (count != null) map['count'] = count!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WikiCommitList &&
          commits == other.commits &&
          count == other.count;
  @override
  int get hashCode => Object.hash(commits, count);
  @override
  String toString() => 'WikiCommitList(commits: $commits, count: $count)';
}
