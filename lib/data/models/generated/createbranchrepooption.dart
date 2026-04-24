part of 'generated_models.dart';

/// CreateBranchRepoOption options when creating a branch in a repository
class CreateBranchRepoOption {
  final String? new_branch_name;
  final String? old_branch_name;
  final String? old_ref_name;
  const CreateBranchRepoOption({
    this.new_branch_name,
    this.old_branch_name,
    this.old_ref_name,
  });
  factory CreateBranchRepoOption.fromJson(Map<String, dynamic> json) {
    return CreateBranchRepoOption(
      new_branch_name: json['new_branch_name'] != null
          ? json['new_branch_name'] as String
          : null,
      old_branch_name: json['old_branch_name'] != null
          ? json['old_branch_name'] as String
          : null,
      old_ref_name: json['old_ref_name'] != null
          ? json['old_ref_name'] as String
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (new_branch_name != null) map['new_branch_name'] = new_branch_name!;
    if (old_branch_name != null) map['old_branch_name'] = old_branch_name!;
    if (old_ref_name != null) map['old_ref_name'] = old_ref_name!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateBranchRepoOption &&
          new_branch_name == other.new_branch_name &&
          old_branch_name == other.old_branch_name &&
          old_ref_name == other.old_ref_name;
  @override
  int get hashCode =>
      Object.hash(new_branch_name, old_branch_name, old_ref_name);
  @override
  String toString() =>
      'CreateBranchRepoOption(new_branch_name: $new_branch_name, old_branch_name: $old_branch_name, old_ref_name: $old_ref_name)';
}
