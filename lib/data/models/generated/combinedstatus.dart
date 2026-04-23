part of 'generated_models.dart';

/// CombinedStatus holds the combined state of several statuses for a single commit
class CombinedStatus {
  final String? commit_url;
  final Repository? repository;
  final String? sha;
  final String? state;
  final List<CommitStatus>? statuses;
  final int? total_count;
  final String? url;
  const CombinedStatus({
    this.commit_url,
    this.repository,
    this.sha,
    this.state,
    this.statuses,
    this.total_count,
    this.url,
  });
  factory CombinedStatus.fromJson(Map<String, dynamic> json) {
    return CombinedStatus(
      commit_url: json['commit_url'] != null ? json['commit_url'] as String : null,
      repository: json['repository'] != null ? Repository.fromJson(json['repository'] as Map<String, dynamic>) : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
      state: json['state'] != null ? json['state'] as String : null,
      statuses: json['statuses'] != null ? (json['statuses'] as List<dynamic>).map((e) => CommitStatus.fromJson(e as Map<String, dynamic>)).toList() : null,
      total_count: json['total_count'] != null ? (json['total_count'] as num).toInt() : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (commit_url != null) map['commit_url'] = commit_url!;
    if (repository != null) map['repository'] = repository!.toJson();
    if (sha != null) map['sha'] = sha!;
    if (state != null) map['state'] = state!;
    if (statuses != null) map['statuses'] = statuses!.map((e) => e.toJson()).toList();
    if (total_count != null) map['total_count'] = total_count!;
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CombinedStatus &&
          commit_url == other.commit_url &&
          repository == other.repository &&
          sha == other.sha &&
          state == other.state &&
          statuses == other.statuses &&
          total_count == other.total_count &&
          url == other.url;
  @override
  int get hashCode => Object.hash(commit_url, repository, sha, state, statuses, total_count, url);
  @override
  String toString() => 'CombinedStatus(commit_url: $commit_url, repository: $repository, sha: $sha, state: $state, statuses: $statuses, total_count: $total_count, url: $url)';
}
