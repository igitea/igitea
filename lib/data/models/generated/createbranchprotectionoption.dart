part of 'generated_models.dart';

/// CreateBranchProtectionOption options for creating a branch protection
class CreateBranchProtectionOption {
  final List<String>? approvals_whitelist_teams;
  final List<String>? approvals_whitelist_username;
  final bool? block_admin_merge_override;
  final bool? block_on_official_review_requests;
  final bool? block_on_outdated_branch;
  final bool? block_on_rejected_reviews;
  final String? branch_name;
  final bool? dismiss_stale_approvals;
  final bool? enable_approvals_whitelist;
  final bool? enable_force_push;
  final bool? enable_force_push_allowlist;
  final bool? enable_merge_whitelist;
  final bool? enable_push;
  final bool? enable_push_whitelist;
  final bool? enable_status_check;
  final bool? force_push_allowlist_deploy_keys;
  final List<String>? force_push_allowlist_teams;
  final List<String>? force_push_allowlist_usernames;
  final bool? ignore_stale_approvals;
  final List<String>? merge_whitelist_teams;
  final List<String>? merge_whitelist_usernames;
  final int? priority;
  final String? protected_file_patterns;
  final bool? push_whitelist_deploy_keys;
  final List<String>? push_whitelist_teams;
  final List<String>? push_whitelist_usernames;
  final bool? require_signed_commits;
  final int? required_approvals;
  final String? rule_name;
  final List<String>? status_check_contexts;
  final String? unprotected_file_patterns;
  const CreateBranchProtectionOption({
    this.approvals_whitelist_teams,
    this.approvals_whitelist_username,
    this.block_admin_merge_override,
    this.block_on_official_review_requests,
    this.block_on_outdated_branch,
    this.block_on_rejected_reviews,
    this.branch_name,
    this.dismiss_stale_approvals,
    this.enable_approvals_whitelist,
    this.enable_force_push,
    this.enable_force_push_allowlist,
    this.enable_merge_whitelist,
    this.enable_push,
    this.enable_push_whitelist,
    this.enable_status_check,
    this.force_push_allowlist_deploy_keys,
    this.force_push_allowlist_teams,
    this.force_push_allowlist_usernames,
    this.ignore_stale_approvals,
    this.merge_whitelist_teams,
    this.merge_whitelist_usernames,
    this.priority,
    this.protected_file_patterns,
    this.push_whitelist_deploy_keys,
    this.push_whitelist_teams,
    this.push_whitelist_usernames,
    this.require_signed_commits,
    this.required_approvals,
    this.rule_name,
    this.status_check_contexts,
    this.unprotected_file_patterns,
  });
  factory CreateBranchProtectionOption.fromJson(Map<String, dynamic> json) {
    return CreateBranchProtectionOption(
      approvals_whitelist_teams: json['approvals_whitelist_teams'] != null
          ? (json['approvals_whitelist_teams'] as List<dynamic>).cast<String>()
          : null,
      approvals_whitelist_username: json['approvals_whitelist_username'] != null
          ? (json['approvals_whitelist_username'] as List<dynamic>)
                .cast<String>()
          : null,
      block_admin_merge_override: json['block_admin_merge_override'] != null
          ? json['block_admin_merge_override'] as bool
          : null,
      block_on_official_review_requests:
          json['block_on_official_review_requests'] != null
          ? json['block_on_official_review_requests'] as bool
          : null,
      block_on_outdated_branch: json['block_on_outdated_branch'] != null
          ? json['block_on_outdated_branch'] as bool
          : null,
      block_on_rejected_reviews: json['block_on_rejected_reviews'] != null
          ? json['block_on_rejected_reviews'] as bool
          : null,
      branch_name: json['branch_name'] != null
          ? json['branch_name'] as String
          : null,
      dismiss_stale_approvals: json['dismiss_stale_approvals'] != null
          ? json['dismiss_stale_approvals'] as bool
          : null,
      enable_approvals_whitelist: json['enable_approvals_whitelist'] != null
          ? json['enable_approvals_whitelist'] as bool
          : null,
      enable_force_push: json['enable_force_push'] != null
          ? json['enable_force_push'] as bool
          : null,
      enable_force_push_allowlist: json['enable_force_push_allowlist'] != null
          ? json['enable_force_push_allowlist'] as bool
          : null,
      enable_merge_whitelist: json['enable_merge_whitelist'] != null
          ? json['enable_merge_whitelist'] as bool
          : null,
      enable_push: json['enable_push'] != null
          ? json['enable_push'] as bool
          : null,
      enable_push_whitelist: json['enable_push_whitelist'] != null
          ? json['enable_push_whitelist'] as bool
          : null,
      enable_status_check: json['enable_status_check'] != null
          ? json['enable_status_check'] as bool
          : null,
      force_push_allowlist_deploy_keys:
          json['force_push_allowlist_deploy_keys'] != null
          ? json['force_push_allowlist_deploy_keys'] as bool
          : null,
      force_push_allowlist_teams: json['force_push_allowlist_teams'] != null
          ? (json['force_push_allowlist_teams'] as List<dynamic>).cast<String>()
          : null,
      force_push_allowlist_usernames:
          json['force_push_allowlist_usernames'] != null
          ? (json['force_push_allowlist_usernames'] as List<dynamic>)
                .cast<String>()
          : null,
      ignore_stale_approvals: json['ignore_stale_approvals'] != null
          ? json['ignore_stale_approvals'] as bool
          : null,
      merge_whitelist_teams: json['merge_whitelist_teams'] != null
          ? (json['merge_whitelist_teams'] as List<dynamic>).cast<String>()
          : null,
      merge_whitelist_usernames: json['merge_whitelist_usernames'] != null
          ? (json['merge_whitelist_usernames'] as List<dynamic>).cast<String>()
          : null,
      priority: json['priority'] != null
          ? (json['priority'] as num).toInt()
          : null,
      protected_file_patterns: json['protected_file_patterns'] != null
          ? json['protected_file_patterns'] as String
          : null,
      push_whitelist_deploy_keys: json['push_whitelist_deploy_keys'] != null
          ? json['push_whitelist_deploy_keys'] as bool
          : null,
      push_whitelist_teams: json['push_whitelist_teams'] != null
          ? (json['push_whitelist_teams'] as List<dynamic>).cast<String>()
          : null,
      push_whitelist_usernames: json['push_whitelist_usernames'] != null
          ? (json['push_whitelist_usernames'] as List<dynamic>).cast<String>()
          : null,
      require_signed_commits: json['require_signed_commits'] != null
          ? json['require_signed_commits'] as bool
          : null,
      required_approvals: json['required_approvals'] != null
          ? (json['required_approvals'] as num).toInt()
          : null,
      rule_name: json['rule_name'] != null ? json['rule_name'] as String : null,
      status_check_contexts: json['status_check_contexts'] != null
          ? (json['status_check_contexts'] as List<dynamic>).cast<String>()
          : null,
      unprotected_file_patterns: json['unprotected_file_patterns'] != null
          ? json['unprotected_file_patterns'] as String
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (approvals_whitelist_teams != null)
      map['approvals_whitelist_teams'] = approvals_whitelist_teams!;
    if (approvals_whitelist_username != null)
      map['approvals_whitelist_username'] = approvals_whitelist_username!;
    if (block_admin_merge_override != null)
      map['block_admin_merge_override'] = block_admin_merge_override!;
    if (block_on_official_review_requests != null)
      map['block_on_official_review_requests'] =
          block_on_official_review_requests!;
    if (block_on_outdated_branch != null)
      map['block_on_outdated_branch'] = block_on_outdated_branch!;
    if (block_on_rejected_reviews != null)
      map['block_on_rejected_reviews'] = block_on_rejected_reviews!;
    if (branch_name != null) map['branch_name'] = branch_name!;
    if (dismiss_stale_approvals != null)
      map['dismiss_stale_approvals'] = dismiss_stale_approvals!;
    if (enable_approvals_whitelist != null)
      map['enable_approvals_whitelist'] = enable_approvals_whitelist!;
    if (enable_force_push != null)
      map['enable_force_push'] = enable_force_push!;
    if (enable_force_push_allowlist != null)
      map['enable_force_push_allowlist'] = enable_force_push_allowlist!;
    if (enable_merge_whitelist != null)
      map['enable_merge_whitelist'] = enable_merge_whitelist!;
    if (enable_push != null) map['enable_push'] = enable_push!;
    if (enable_push_whitelist != null)
      map['enable_push_whitelist'] = enable_push_whitelist!;
    if (enable_status_check != null)
      map['enable_status_check'] = enable_status_check!;
    if (force_push_allowlist_deploy_keys != null)
      map['force_push_allowlist_deploy_keys'] =
          force_push_allowlist_deploy_keys!;
    if (force_push_allowlist_teams != null)
      map['force_push_allowlist_teams'] = force_push_allowlist_teams!;
    if (force_push_allowlist_usernames != null)
      map['force_push_allowlist_usernames'] = force_push_allowlist_usernames!;
    if (ignore_stale_approvals != null)
      map['ignore_stale_approvals'] = ignore_stale_approvals!;
    if (merge_whitelist_teams != null)
      map['merge_whitelist_teams'] = merge_whitelist_teams!;
    if (merge_whitelist_usernames != null)
      map['merge_whitelist_usernames'] = merge_whitelist_usernames!;
    if (priority != null) map['priority'] = priority!;
    if (protected_file_patterns != null)
      map['protected_file_patterns'] = protected_file_patterns!;
    if (push_whitelist_deploy_keys != null)
      map['push_whitelist_deploy_keys'] = push_whitelist_deploy_keys!;
    if (push_whitelist_teams != null)
      map['push_whitelist_teams'] = push_whitelist_teams!;
    if (push_whitelist_usernames != null)
      map['push_whitelist_usernames'] = push_whitelist_usernames!;
    if (require_signed_commits != null)
      map['require_signed_commits'] = require_signed_commits!;
    if (required_approvals != null)
      map['required_approvals'] = required_approvals!;
    if (rule_name != null) map['rule_name'] = rule_name!;
    if (status_check_contexts != null)
      map['status_check_contexts'] = status_check_contexts!;
    if (unprotected_file_patterns != null)
      map['unprotected_file_patterns'] = unprotected_file_patterns!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateBranchProtectionOption &&
          approvals_whitelist_teams == other.approvals_whitelist_teams &&
          approvals_whitelist_username == other.approvals_whitelist_username &&
          block_admin_merge_override == other.block_admin_merge_override &&
          block_on_official_review_requests ==
              other.block_on_official_review_requests &&
          block_on_outdated_branch == other.block_on_outdated_branch &&
          block_on_rejected_reviews == other.block_on_rejected_reviews &&
          branch_name == other.branch_name &&
          dismiss_stale_approvals == other.dismiss_stale_approvals &&
          enable_approvals_whitelist == other.enable_approvals_whitelist &&
          enable_force_push == other.enable_force_push &&
          enable_force_push_allowlist == other.enable_force_push_allowlist &&
          enable_merge_whitelist == other.enable_merge_whitelist &&
          enable_push == other.enable_push &&
          enable_push_whitelist == other.enable_push_whitelist &&
          enable_status_check == other.enable_status_check &&
          force_push_allowlist_deploy_keys ==
              other.force_push_allowlist_deploy_keys &&
          force_push_allowlist_teams == other.force_push_allowlist_teams &&
          force_push_allowlist_usernames ==
              other.force_push_allowlist_usernames &&
          ignore_stale_approvals == other.ignore_stale_approvals &&
          merge_whitelist_teams == other.merge_whitelist_teams &&
          merge_whitelist_usernames == other.merge_whitelist_usernames &&
          priority == other.priority &&
          protected_file_patterns == other.protected_file_patterns &&
          push_whitelist_deploy_keys == other.push_whitelist_deploy_keys &&
          push_whitelist_teams == other.push_whitelist_teams &&
          push_whitelist_usernames == other.push_whitelist_usernames &&
          require_signed_commits == other.require_signed_commits &&
          required_approvals == other.required_approvals &&
          rule_name == other.rule_name &&
          status_check_contexts == other.status_check_contexts &&
          unprotected_file_patterns == other.unprotected_file_patterns;
  @override
  int get hashCode => Object.hashAll([
    approvals_whitelist_teams,
    approvals_whitelist_username,
    block_admin_merge_override,
    block_on_official_review_requests,
    block_on_outdated_branch,
    block_on_rejected_reviews,
    branch_name,
    dismiss_stale_approvals,
    enable_approvals_whitelist,
    enable_force_push,
    enable_force_push_allowlist,
    enable_merge_whitelist,
    enable_push,
    enable_push_whitelist,
    enable_status_check,
    force_push_allowlist_deploy_keys,
    force_push_allowlist_teams,
    force_push_allowlist_usernames,
    ignore_stale_approvals,
    merge_whitelist_teams,
    merge_whitelist_usernames,
    priority,
    protected_file_patterns,
    push_whitelist_deploy_keys,
    push_whitelist_teams,
    push_whitelist_usernames,
    require_signed_commits,
    required_approvals,
    rule_name,
    status_check_contexts,
    unprotected_file_patterns,
  ]);
  @override
  String toString() =>
      'CreateBranchProtectionOption(approvals_whitelist_teams: $approvals_whitelist_teams, approvals_whitelist_username: $approvals_whitelist_username, block_admin_merge_override: $block_admin_merge_override, block_on_official_review_requests: $block_on_official_review_requests, block_on_outdated_branch: $block_on_outdated_branch, block_on_rejected_reviews: $block_on_rejected_reviews, branch_name: $branch_name, dismiss_stale_approvals: $dismiss_stale_approvals, enable_approvals_whitelist: $enable_approvals_whitelist, enable_force_push: $enable_force_push, enable_force_push_allowlist: $enable_force_push_allowlist, enable_merge_whitelist: $enable_merge_whitelist, enable_push: $enable_push, enable_push_whitelist: $enable_push_whitelist, enable_status_check: $enable_status_check, force_push_allowlist_deploy_keys: $force_push_allowlist_deploy_keys, force_push_allowlist_teams: $force_push_allowlist_teams, force_push_allowlist_usernames: $force_push_allowlist_usernames, ignore_stale_approvals: $ignore_stale_approvals, merge_whitelist_teams: $merge_whitelist_teams, merge_whitelist_usernames: $merge_whitelist_usernames, priority: $priority, protected_file_patterns: $protected_file_patterns, push_whitelist_deploy_keys: $push_whitelist_deploy_keys, push_whitelist_teams: $push_whitelist_teams, push_whitelist_usernames: $push_whitelist_usernames, require_signed_commits: $require_signed_commits, required_approvals: $required_approvals, rule_name: $rule_name, status_check_contexts: $status_check_contexts, unprotected_file_patterns: $unprotected_file_patterns)';
}
