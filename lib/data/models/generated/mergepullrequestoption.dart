part of 'generated_models.dart';

/// MergePullRequestForm form for merging Pull Request
class MergePullRequestOption {
  final String? Do;
  final String? MergeCommitID;
  final String? MergeMessageField;
  final String? MergeTitleField;
  final bool? delete_branch_after_merge;
  final bool? force_merge;
  final String? head_commit_id;
  final bool? merge_when_checks_succeed;
  const MergePullRequestOption({
    this.Do,
    this.MergeCommitID,
    this.MergeMessageField,
    this.MergeTitleField,
    this.delete_branch_after_merge,
    this.force_merge,
    this.head_commit_id,
    this.merge_when_checks_succeed,
  });
  factory MergePullRequestOption.fromJson(Map<String, dynamic> json) {
    return MergePullRequestOption(
      Do: json['Do'] != null ? json['Do'] as String : null,
      MergeCommitID: json['MergeCommitID'] != null
          ? json['MergeCommitID'] as String
          : null,
      MergeMessageField: json['MergeMessageField'] != null
          ? json['MergeMessageField'] as String
          : null,
      MergeTitleField: json['MergeTitleField'] != null
          ? json['MergeTitleField'] as String
          : null,
      delete_branch_after_merge: json['delete_branch_after_merge'] != null
          ? json['delete_branch_after_merge'] as bool
          : null,
      force_merge: json['force_merge'] != null
          ? json['force_merge'] as bool
          : null,
      head_commit_id: json['head_commit_id'] != null
          ? json['head_commit_id'] as String
          : null,
      merge_when_checks_succeed: json['merge_when_checks_succeed'] != null
          ? json['merge_when_checks_succeed'] as bool
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (Do != null) map['Do'] = Do!;
    if (MergeCommitID != null) map['MergeCommitID'] = MergeCommitID!;
    if (MergeMessageField != null)
      map['MergeMessageField'] = MergeMessageField!;
    if (MergeTitleField != null) map['MergeTitleField'] = MergeTitleField!;
    if (delete_branch_after_merge != null)
      map['delete_branch_after_merge'] = delete_branch_after_merge!;
    if (force_merge != null) map['force_merge'] = force_merge!;
    if (head_commit_id != null) map['head_commit_id'] = head_commit_id!;
    if (merge_when_checks_succeed != null)
      map['merge_when_checks_succeed'] = merge_when_checks_succeed!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MergePullRequestOption &&
          Do == other.Do &&
          MergeCommitID == other.MergeCommitID &&
          MergeMessageField == other.MergeMessageField &&
          MergeTitleField == other.MergeTitleField &&
          delete_branch_after_merge == other.delete_branch_after_merge &&
          force_merge == other.force_merge &&
          head_commit_id == other.head_commit_id &&
          merge_when_checks_succeed == other.merge_when_checks_succeed;
  @override
  int get hashCode => Object.hash(
    Do,
    MergeCommitID,
    MergeMessageField,
    MergeTitleField,
    delete_branch_after_merge,
    force_merge,
    head_commit_id,
    merge_when_checks_succeed,
  );
  @override
  String toString() =>
      'MergePullRequestOption(Do: $Do, MergeCommitID: $MergeCommitID, MergeMessageField: $MergeMessageField, MergeTitleField: $MergeTitleField, delete_branch_after_merge: $delete_branch_after_merge, force_merge: $force_merge, head_commit_id: $head_commit_id, merge_when_checks_succeed: $merge_when_checks_succeed)';
}
