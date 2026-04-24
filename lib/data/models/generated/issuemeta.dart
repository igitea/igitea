part of 'generated_models.dart';

/// IssueMeta basic issue information
class IssueMeta {
  final int? index;
  final String? owner;
  final String? repo;
  const IssueMeta({this.index, this.owner, this.repo});
  factory IssueMeta.fromJson(Map<String, dynamic> json) {
    return IssueMeta(
      index: json['index'] != null ? (json['index'] as num).toInt() : null,
      owner: json['owner'] != null ? json['owner'] as String : null,
      repo: json['repo'] != null ? json['repo'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (index != null) map['index'] = index!;
    if (owner != null) map['owner'] = owner!;
    if (repo != null) map['repo'] = repo!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueMeta &&
          index == other.index &&
          owner == other.owner &&
          repo == other.repo;
  @override
  int get hashCode => Object.hash(index, owner, repo);
  @override
  String toString() => 'IssueMeta(index: $index, owner: $owner, repo: $repo)';
}
