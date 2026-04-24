part of 'generated_models.dart';

/// PRBranchInfo information about a branch
class PRBranchInfo {
  final String? label;
  final String? ref;
  final Repository? repo;
  final int? repo_id;
  final String? sha;
  const PRBranchInfo({this.label, this.ref, this.repo, this.repo_id, this.sha});
  factory PRBranchInfo.fromJson(Map<String, dynamic> json) {
    return PRBranchInfo(
      label: json['label'] != null ? json['label'] as String : null,
      ref: json['ref'] != null ? json['ref'] as String : null,
      repo: json['repo'] != null
          ? Repository.fromJson(json['repo'] as Map<String, dynamic>)
          : null,
      repo_id: json['repo_id'] != null
          ? (json['repo_id'] as num).toInt()
          : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (label != null) map['label'] = label!;
    if (ref != null) map['ref'] = ref!;
    if (repo != null) map['repo'] = repo!.toJson();
    if (repo_id != null) map['repo_id'] = repo_id!;
    if (sha != null) map['sha'] = sha!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PRBranchInfo &&
          label == other.label &&
          ref == other.ref &&
          repo == other.repo &&
          repo_id == other.repo_id &&
          sha == other.sha;
  @override
  int get hashCode => Object.hash(label, ref, repo, repo_id, sha);
  @override
  String toString() =>
      'PRBranchInfo(label: $label, ref: $ref, repo: $repo, repo_id: $repo_id, sha: $sha)';
}
