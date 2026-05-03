part of 'generated_models.dart';

/// EditRepoOption options when editing a repository's properties
class EditRepoOption {
  final bool? allow_fast_forward_only_merge;
  final bool? allow_manual_merge;
  final bool? allow_merge_commits;
  final bool? allow_rebase;
  final bool? allow_rebase_explicit;
  final bool? allow_rebase_update;
  final bool? allow_squash_merge;
  final bool? archived;
  final bool? autodetect_manual_merge;
  final bool? default_allow_maintainer_edit;
  final String? default_branch;
  final bool? default_delete_branch_after_merge;
  final String? default_merge_style;
  final String? description;
  final bool? enable_prune;
  final ExternalTracker? external_tracker;
  final ExternalWiki? external_wiki;
  final bool? has_actions;
  final bool? has_code;
  final bool? has_issues;
  final bool? has_packages;
  final bool? has_projects;
  final bool? has_pull_requests;
  final bool? has_releases;
  final bool? has_wiki;
  final bool? ignore_whitespace_conflicts;
  final InternalTracker? internal_tracker;
  final String? mirror_interval;
  final String? name;
  final bool? private;
  final String? projects_mode;
  final bool? template;
  final String? website;
  const EditRepoOption({
    this.allow_fast_forward_only_merge,
    this.allow_manual_merge,
    this.allow_merge_commits,
    this.allow_rebase,
    this.allow_rebase_explicit,
    this.allow_rebase_update,
    this.allow_squash_merge,
    this.archived,
    this.autodetect_manual_merge,
    this.default_allow_maintainer_edit,
    this.default_branch,
    this.default_delete_branch_after_merge,
    this.default_merge_style,
    this.description,
    this.enable_prune,
    this.external_tracker,
    this.external_wiki,
    this.has_actions,
    this.has_code,
    this.has_issues,
    this.has_packages,
    this.has_projects,
    this.has_pull_requests,
    this.has_releases,
    this.has_wiki,
    this.ignore_whitespace_conflicts,
    this.internal_tracker,
    this.mirror_interval,
    this.name,
    this.private,
    this.projects_mode,
    this.template,
    this.website,
  });
  factory EditRepoOption.fromJson(Map<String, dynamic> json) {
    return EditRepoOption(
      allow_fast_forward_only_merge: json['allow_fast_forward_only_merge'] != null ? json['allow_fast_forward_only_merge'] as bool : null,
      allow_manual_merge: json['allow_manual_merge'] != null ? json['allow_manual_merge'] as bool : null,
      allow_merge_commits: json['allow_merge_commits'] != null ? json['allow_merge_commits'] as bool : null,
      allow_rebase: json['allow_rebase'] != null ? json['allow_rebase'] as bool : null,
      allow_rebase_explicit: json['allow_rebase_explicit'] != null ? json['allow_rebase_explicit'] as bool : null,
      allow_rebase_update: json['allow_rebase_update'] != null ? json['allow_rebase_update'] as bool : null,
      allow_squash_merge: json['allow_squash_merge'] != null ? json['allow_squash_merge'] as bool : null,
      archived: json['archived'] != null ? json['archived'] as bool : null,
      autodetect_manual_merge: json['autodetect_manual_merge'] != null ? json['autodetect_manual_merge'] as bool : null,
      default_allow_maintainer_edit: json['default_allow_maintainer_edit'] != null ? json['default_allow_maintainer_edit'] as bool : null,
      default_branch: json['default_branch'] != null ? json['default_branch'] as String : null,
      default_delete_branch_after_merge: json['default_delete_branch_after_merge'] != null ? json['default_delete_branch_after_merge'] as bool : null,
      default_merge_style: json['default_merge_style'] != null ? json['default_merge_style'] as String : null,
      description: json['description'] != null ? json['description'] as String : null,
      enable_prune: json['enable_prune'] != null ? json['enable_prune'] as bool : null,
      external_tracker: json['external_tracker'] != null ? ExternalTracker.fromJson(json['external_tracker'] as Map<String, dynamic>) : null,
      external_wiki: json['external_wiki'] != null ? ExternalWiki.fromJson(json['external_wiki'] as Map<String, dynamic>) : null,
      has_actions: json['has_actions'] != null ? json['has_actions'] as bool : null,
      has_code: json['has_code'] != null ? json['has_code'] as bool : null,
      has_issues: json['has_issues'] != null ? json['has_issues'] as bool : null,
      has_packages: json['has_packages'] != null ? json['has_packages'] as bool : null,
      has_projects: json['has_projects'] != null ? json['has_projects'] as bool : null,
      has_pull_requests: json['has_pull_requests'] != null ? json['has_pull_requests'] as bool : null,
      has_releases: json['has_releases'] != null ? json['has_releases'] as bool : null,
      has_wiki: json['has_wiki'] != null ? json['has_wiki'] as bool : null,
      ignore_whitespace_conflicts: json['ignore_whitespace_conflicts'] != null ? json['ignore_whitespace_conflicts'] as bool : null,
      internal_tracker: json['internal_tracker'] != null ? InternalTracker.fromJson(json['internal_tracker'] as Map<String, dynamic>) : null,
      mirror_interval: json['mirror_interval'] != null ? json['mirror_interval'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      private: json['private'] != null ? json['private'] as bool : null,
      projects_mode: json['projects_mode'] != null ? json['projects_mode'] as String : null,
      template: json['template'] != null ? json['template'] as bool : null,
      website: json['website'] != null ? json['website'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (allow_fast_forward_only_merge != null) map['allow_fast_forward_only_merge'] = allow_fast_forward_only_merge!;
    if (allow_manual_merge != null) map['allow_manual_merge'] = allow_manual_merge!;
    if (allow_merge_commits != null) map['allow_merge_commits'] = allow_merge_commits!;
    if (allow_rebase != null) map['allow_rebase'] = allow_rebase!;
    if (allow_rebase_explicit != null) map['allow_rebase_explicit'] = allow_rebase_explicit!;
    if (allow_rebase_update != null) map['allow_rebase_update'] = allow_rebase_update!;
    if (allow_squash_merge != null) map['allow_squash_merge'] = allow_squash_merge!;
    if (archived != null) map['archived'] = archived!;
    if (autodetect_manual_merge != null) map['autodetect_manual_merge'] = autodetect_manual_merge!;
    if (default_allow_maintainer_edit != null) map['default_allow_maintainer_edit'] = default_allow_maintainer_edit!;
    if (default_branch != null) map['default_branch'] = default_branch!;
    if (default_delete_branch_after_merge != null) map['default_delete_branch_after_merge'] = default_delete_branch_after_merge!;
    if (default_merge_style != null) map['default_merge_style'] = default_merge_style!;
    if (description != null) map['description'] = description!;
    if (enable_prune != null) map['enable_prune'] = enable_prune!;
    if (external_tracker != null) map['external_tracker'] = external_tracker!.toJson();
    if (external_wiki != null) map['external_wiki'] = external_wiki!.toJson();
    if (has_actions != null) map['has_actions'] = has_actions!;
    if (has_code != null) map['has_code'] = has_code!;
    if (has_issues != null) map['has_issues'] = has_issues!;
    if (has_packages != null) map['has_packages'] = has_packages!;
    if (has_projects != null) map['has_projects'] = has_projects!;
    if (has_pull_requests != null) map['has_pull_requests'] = has_pull_requests!;
    if (has_releases != null) map['has_releases'] = has_releases!;
    if (has_wiki != null) map['has_wiki'] = has_wiki!;
    if (ignore_whitespace_conflicts != null) map['ignore_whitespace_conflicts'] = ignore_whitespace_conflicts!;
    if (internal_tracker != null) map['internal_tracker'] = internal_tracker!.toJson();
    if (mirror_interval != null) map['mirror_interval'] = mirror_interval!;
    if (name != null) map['name'] = name!;
    if (private != null) map['private'] = private!;
    if (projects_mode != null) map['projects_mode'] = projects_mode!;
    if (template != null) map['template'] = template!;
    if (website != null) map['website'] = website!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditRepoOption &&
          allow_fast_forward_only_merge == other.allow_fast_forward_only_merge &&
          allow_manual_merge == other.allow_manual_merge &&
          allow_merge_commits == other.allow_merge_commits &&
          allow_rebase == other.allow_rebase &&
          allow_rebase_explicit == other.allow_rebase_explicit &&
          allow_rebase_update == other.allow_rebase_update &&
          allow_squash_merge == other.allow_squash_merge &&
          archived == other.archived &&
          autodetect_manual_merge == other.autodetect_manual_merge &&
          default_allow_maintainer_edit == other.default_allow_maintainer_edit &&
          default_branch == other.default_branch &&
          default_delete_branch_after_merge == other.default_delete_branch_after_merge &&
          default_merge_style == other.default_merge_style &&
          description == other.description &&
          enable_prune == other.enable_prune &&
          external_tracker == other.external_tracker &&
          external_wiki == other.external_wiki &&
          has_actions == other.has_actions &&
          has_code == other.has_code &&
          has_issues == other.has_issues &&
          has_packages == other.has_packages &&
          has_projects == other.has_projects &&
          has_pull_requests == other.has_pull_requests &&
          has_releases == other.has_releases &&
          has_wiki == other.has_wiki &&
          ignore_whitespace_conflicts == other.ignore_whitespace_conflicts &&
          internal_tracker == other.internal_tracker &&
          mirror_interval == other.mirror_interval &&
          name == other.name &&
          private == other.private &&
          projects_mode == other.projects_mode &&
          template == other.template &&
          website == other.website;
  @override
  int get hashCode => Object.hashAll([allow_fast_forward_only_merge, allow_manual_merge, allow_merge_commits, allow_rebase, allow_rebase_explicit, allow_rebase_update, allow_squash_merge, archived, autodetect_manual_merge, default_allow_maintainer_edit, default_branch, default_delete_branch_after_merge, default_merge_style, description, enable_prune, external_tracker, external_wiki, has_actions, has_code, has_issues, has_packages, has_projects, has_pull_requests, has_releases, has_wiki, ignore_whitespace_conflicts, internal_tracker, mirror_interval, name, private, projects_mode, template, website]);
  @override
  String toString() => 'EditRepoOption(allow_fast_forward_only_merge: $allow_fast_forward_only_merge, allow_manual_merge: $allow_manual_merge, allow_merge_commits: $allow_merge_commits, allow_rebase: $allow_rebase, allow_rebase_explicit: $allow_rebase_explicit, allow_rebase_update: $allow_rebase_update, allow_squash_merge: $allow_squash_merge, archived: $archived, autodetect_manual_merge: $autodetect_manual_merge, default_allow_maintainer_edit: $default_allow_maintainer_edit, default_branch: $default_branch, default_delete_branch_after_merge: $default_delete_branch_after_merge, default_merge_style: $default_merge_style, description: $description, enable_prune: $enable_prune, external_tracker: $external_tracker, external_wiki: $external_wiki, has_actions: $has_actions, has_code: $has_code, has_issues: $has_issues, has_packages: $has_packages, has_projects: $has_projects, has_pull_requests: $has_pull_requests, has_releases: $has_releases, has_wiki: $has_wiki, ignore_whitespace_conflicts: $ignore_whitespace_conflicts, internal_tracker: $internal_tracker, mirror_interval: $mirror_interval, name: $name, private: $private, projects_mode: $projects_mode, template: $template, website: $website)';
}
