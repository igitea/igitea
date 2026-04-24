part of 'generated_models.dart';

/// Branch represents a repository branch
class Branch {
  final PayloadCommit? commit;
  final String? effective_branch_protection_name;
  final bool? enable_status_check;
  final String? name;
  final bool? protected;
  final int? required_approvals;
  final List<String>? status_check_contexts;
  final bool? user_can_merge;
  final bool? user_can_push;
  const Branch({
    this.commit,
    this.effective_branch_protection_name,
    this.enable_status_check,
    this.name,
    this.protected,
    this.required_approvals,
    this.status_check_contexts,
    this.user_can_merge,
    this.user_can_push,
  });
  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      commit: json['commit'] != null
          ? PayloadCommit.fromJson(json['commit'] as Map<String, dynamic>)
          : null,
      effective_branch_protection_name:
          json['effective_branch_protection_name'] != null
          ? json['effective_branch_protection_name'] as String
          : null,
      enable_status_check: json['enable_status_check'] != null
          ? json['enable_status_check'] as bool
          : null,
      name: json['name'] != null ? json['name'] as String : null,
      protected: json['protected'] != null ? json['protected'] as bool : null,
      required_approvals: json['required_approvals'] != null
          ? (json['required_approvals'] as num).toInt()
          : null,
      status_check_contexts: json['status_check_contexts'] != null
          ? (json['status_check_contexts'] as List<dynamic>).cast<String>()
          : null,
      user_can_merge: json['user_can_merge'] != null
          ? json['user_can_merge'] as bool
          : null,
      user_can_push: json['user_can_push'] != null
          ? json['user_can_push'] as bool
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (commit != null) map['commit'] = commit!.toJson();
    if (effective_branch_protection_name != null)
      map['effective_branch_protection_name'] =
          effective_branch_protection_name!;
    if (enable_status_check != null)
      map['enable_status_check'] = enable_status_check!;
    if (name != null) map['name'] = name!;
    if (protected != null) map['protected'] = protected!;
    if (required_approvals != null)
      map['required_approvals'] = required_approvals!;
    if (status_check_contexts != null)
      map['status_check_contexts'] = status_check_contexts!;
    if (user_can_merge != null) map['user_can_merge'] = user_can_merge!;
    if (user_can_push != null) map['user_can_push'] = user_can_push!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Branch &&
          commit == other.commit &&
          effective_branch_protection_name ==
              other.effective_branch_protection_name &&
          enable_status_check == other.enable_status_check &&
          name == other.name &&
          protected == other.protected &&
          required_approvals == other.required_approvals &&
          status_check_contexts == other.status_check_contexts &&
          user_can_merge == other.user_can_merge &&
          user_can_push == other.user_can_push;
  @override
  int get hashCode => Object.hash(
    commit,
    effective_branch_protection_name,
    enable_status_check,
    name,
    protected,
    required_approvals,
    status_check_contexts,
    user_can_merge,
    user_can_push,
  );
  @override
  String toString() =>
      'Branch(commit: $commit, effective_branch_protection_name: $effective_branch_protection_name, enable_status_check: $enable_status_check, name: $name, protected: $protected, required_approvals: $required_approvals, status_check_contexts: $status_check_contexts, user_can_merge: $user_can_merge, user_can_push: $user_can_push)';
}
