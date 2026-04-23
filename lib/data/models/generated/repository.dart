part of 'generated_models.dart';

/// Repository represents a repository
class Repository {
  final bool? allow_fast_forward_only_merge;
  final bool? allow_manual_merge;
  final bool? allow_merge_commits;
  final bool? allow_rebase;
  final bool? allow_rebase_explicit;
  final bool? allow_rebase_update;
  final bool? allow_squash_merge;
  final bool? archived;
  final DateTime? archived_at;
  final bool? autodetect_manual_merge;
  final String? avatar_url;
  final String? clone_url;
  final DateTime? created_at;
  final bool? default_allow_maintainer_edit;
  final String? default_branch;
  final bool? default_delete_branch_after_merge;
  final String? default_merge_style;
  final String? description;
  final bool? empty;
  final ExternalTracker? external_tracker;
  final ExternalWiki? external_wiki;
  final bool? fork;
  final int? forks_count;
  final String? full_name;
  final bool? has_actions;
  final bool? has_code;
  final bool? has_issues;
  final bool? has_packages;
  final bool? has_projects;
  final bool? has_pull_requests;
  final bool? has_releases;
  final bool? has_wiki;
  final String? html_url;
  final int? id;
  final bool? ignore_whitespace_conflicts;
  final bool? internal;
  final InternalTracker? internal_tracker;
  final String? language;
  final String? languages_url;
  final List<String>? licenses;
  final String? link;
  final bool? mirror;
  final String? mirror_interval;
  final DateTime? mirror_updated;
  final String? name;
  final String? object_format_name;
  final int? open_issues_count;
  final int? open_pr_counter;
  final String? original_url;
  final User? owner;
  final Repository? parent;
  final Permission? permissions;
  final bool? private;
  final String? projects_mode;
  final int? release_counter;
  final RepoTransfer? repo_transfer;
  final int? size;
  final String? ssh_url;
  final int? stars_count;
  final bool? template;
  final List<String>? topics;
  final DateTime? updated_at;
  final String? url;
  final int? watchers_count;
  final String? website;
  const Repository({
    this.allow_fast_forward_only_merge,
    this.allow_manual_merge,
    this.allow_merge_commits,
    this.allow_rebase,
    this.allow_rebase_explicit,
    this.allow_rebase_update,
    this.allow_squash_merge,
    this.archived,
    this.archived_at,
    this.autodetect_manual_merge,
    this.avatar_url,
    this.clone_url,
    this.created_at,
    this.default_allow_maintainer_edit,
    this.default_branch,
    this.default_delete_branch_after_merge,
    this.default_merge_style,
    this.description,
    this.empty,
    this.external_tracker,
    this.external_wiki,
    this.fork,
    this.forks_count,
    this.full_name,
    this.has_actions,
    this.has_code,
    this.has_issues,
    this.has_packages,
    this.has_projects,
    this.has_pull_requests,
    this.has_releases,
    this.has_wiki,
    this.html_url,
    this.id,
    this.ignore_whitespace_conflicts,
    this.internal,
    this.internal_tracker,
    this.language,
    this.languages_url,
    this.licenses,
    this.link,
    this.mirror,
    this.mirror_interval,
    this.mirror_updated,
    this.name,
    this.object_format_name,
    this.open_issues_count,
    this.open_pr_counter,
    this.original_url,
    this.owner,
    this.parent,
    this.permissions,
    this.private,
    this.projects_mode,
    this.release_counter,
    this.repo_transfer,
    this.size,
    this.ssh_url,
    this.stars_count,
    this.template,
    this.topics,
    this.updated_at,
    this.url,
    this.watchers_count,
    this.website,
  });
  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      allow_fast_forward_only_merge: json['allow_fast_forward_only_merge'] != null ? json['allow_fast_forward_only_merge'] as bool : null,
      allow_manual_merge: json['allow_manual_merge'] != null ? json['allow_manual_merge'] as bool : null,
      allow_merge_commits: json['allow_merge_commits'] != null ? json['allow_merge_commits'] as bool : null,
      allow_rebase: json['allow_rebase'] != null ? json['allow_rebase'] as bool : null,
      allow_rebase_explicit: json['allow_rebase_explicit'] != null ? json['allow_rebase_explicit'] as bool : null,
      allow_rebase_update: json['allow_rebase_update'] != null ? json['allow_rebase_update'] as bool : null,
      allow_squash_merge: json['allow_squash_merge'] != null ? json['allow_squash_merge'] as bool : null,
      archived: json['archived'] != null ? json['archived'] as bool : null,
      archived_at: json['archived_at'] != null ? DateTime.parse(json['archived_at'] as String) : null,
      autodetect_manual_merge: json['autodetect_manual_merge'] != null ? json['autodetect_manual_merge'] as bool : null,
      avatar_url: json['avatar_url'] != null ? json['avatar_url'] as String : null,
      clone_url: json['clone_url'] != null ? json['clone_url'] as String : null,
      created_at: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      default_allow_maintainer_edit: json['default_allow_maintainer_edit'] != null ? json['default_allow_maintainer_edit'] as bool : null,
      default_branch: json['default_branch'] != null ? json['default_branch'] as String : null,
      default_delete_branch_after_merge: json['default_delete_branch_after_merge'] != null ? json['default_delete_branch_after_merge'] as bool : null,
      default_merge_style: json['default_merge_style'] != null ? json['default_merge_style'] as String : null,
      description: json['description'] != null ? json['description'] as String : null,
      empty: json['empty'] != null ? json['empty'] as bool : null,
      external_tracker: json['external_tracker'] != null ? ExternalTracker.fromJson(json['external_tracker'] as Map<String, dynamic>) : null,
      external_wiki: json['external_wiki'] != null ? ExternalWiki.fromJson(json['external_wiki'] as Map<String, dynamic>) : null,
      fork: json['fork'] != null ? json['fork'] as bool : null,
      forks_count: json['forks_count'] != null ? (json['forks_count'] as num).toInt() : null,
      full_name: json['full_name'] != null ? json['full_name'] as String : null,
      has_actions: json['has_actions'] != null ? json['has_actions'] as bool : null,
      has_code: json['has_code'] != null ? json['has_code'] as bool : null,
      has_issues: json['has_issues'] != null ? json['has_issues'] as bool : null,
      has_packages: json['has_packages'] != null ? json['has_packages'] as bool : null,
      has_projects: json['has_projects'] != null ? json['has_projects'] as bool : null,
      has_pull_requests: json['has_pull_requests'] != null ? json['has_pull_requests'] as bool : null,
      has_releases: json['has_releases'] != null ? json['has_releases'] as bool : null,
      has_wiki: json['has_wiki'] != null ? json['has_wiki'] as bool : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      ignore_whitespace_conflicts: json['ignore_whitespace_conflicts'] != null ? json['ignore_whitespace_conflicts'] as bool : null,
      internal: json['internal'] != null ? json['internal'] as bool : null,
      internal_tracker: json['internal_tracker'] != null ? InternalTracker.fromJson(json['internal_tracker'] as Map<String, dynamic>) : null,
      language: json['language'] != null ? json['language'] as String : null,
      languages_url: json['languages_url'] != null ? json['languages_url'] as String : null,
      licenses: json['licenses'] != null ? (json['licenses'] as List<dynamic>).cast<String>() : null,
      link: json['link'] != null ? json['link'] as String : null,
      mirror: json['mirror'] != null ? json['mirror'] as bool : null,
      mirror_interval: json['mirror_interval'] != null ? json['mirror_interval'] as String : null,
      mirror_updated: json['mirror_updated'] != null ? DateTime.parse(json['mirror_updated'] as String) : null,
      name: json['name'] != null ? json['name'] as String : null,
      object_format_name: json['object_format_name'] != null ? json['object_format_name'] as String : null,
      open_issues_count: json['open_issues_count'] != null ? (json['open_issues_count'] as num).toInt() : null,
      open_pr_counter: json['open_pr_counter'] != null ? (json['open_pr_counter'] as num).toInt() : null,
      original_url: json['original_url'] != null ? json['original_url'] as String : null,
      owner: json['owner'] != null ? User.fromJson(json['owner'] as Map<String, dynamic>) : null,
      parent: json['parent'] != null ? Repository.fromJson(json['parent'] as Map<String, dynamic>) : null,
      permissions: json['permissions'] != null ? Permission.fromJson(json['permissions'] as Map<String, dynamic>) : null,
      private: json['private'] != null ? json['private'] as bool : null,
      projects_mode: json['projects_mode'] != null ? json['projects_mode'] as String : null,
      release_counter: json['release_counter'] != null ? (json['release_counter'] as num).toInt() : null,
      repo_transfer: json['repo_transfer'] != null ? RepoTransfer.fromJson(json['repo_transfer'] as Map<String, dynamic>) : null,
      size: json['size'] != null ? (json['size'] as num).toInt() : null,
      ssh_url: json['ssh_url'] != null ? json['ssh_url'] as String : null,
      stars_count: json['stars_count'] != null ? (json['stars_count'] as num).toInt() : null,
      template: json['template'] != null ? json['template'] as bool : null,
      topics: json['topics'] != null ? (json['topics'] as List<dynamic>).cast<String>() : null,
      updated_at: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      url: json['url'] != null ? json['url'] as String : null,
      watchers_count: json['watchers_count'] != null ? (json['watchers_count'] as num).toInt() : null,
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
    if (archived_at != null) map['archived_at'] = archived_at!.toIso8601String();
    if (autodetect_manual_merge != null) map['autodetect_manual_merge'] = autodetect_manual_merge!;
    if (avatar_url != null) map['avatar_url'] = avatar_url!;
    if (clone_url != null) map['clone_url'] = clone_url!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (default_allow_maintainer_edit != null) map['default_allow_maintainer_edit'] = default_allow_maintainer_edit!;
    if (default_branch != null) map['default_branch'] = default_branch!;
    if (default_delete_branch_after_merge != null) map['default_delete_branch_after_merge'] = default_delete_branch_after_merge!;
    if (default_merge_style != null) map['default_merge_style'] = default_merge_style!;
    if (description != null) map['description'] = description!;
    if (empty != null) map['empty'] = empty!;
    if (external_tracker != null) map['external_tracker'] = external_tracker!.toJson();
    if (external_wiki != null) map['external_wiki'] = external_wiki!.toJson();
    if (fork != null) map['fork'] = fork!;
    if (forks_count != null) map['forks_count'] = forks_count!;
    if (full_name != null) map['full_name'] = full_name!;
    if (has_actions != null) map['has_actions'] = has_actions!;
    if (has_code != null) map['has_code'] = has_code!;
    if (has_issues != null) map['has_issues'] = has_issues!;
    if (has_packages != null) map['has_packages'] = has_packages!;
    if (has_projects != null) map['has_projects'] = has_projects!;
    if (has_pull_requests != null) map['has_pull_requests'] = has_pull_requests!;
    if (has_releases != null) map['has_releases'] = has_releases!;
    if (has_wiki != null) map['has_wiki'] = has_wiki!;
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (ignore_whitespace_conflicts != null) map['ignore_whitespace_conflicts'] = ignore_whitespace_conflicts!;
    if (internal != null) map['internal'] = internal!;
    if (internal_tracker != null) map['internal_tracker'] = internal_tracker!.toJson();
    if (language != null) map['language'] = language!;
    if (languages_url != null) map['languages_url'] = languages_url!;
    if (licenses != null) map['licenses'] = licenses!;
    if (link != null) map['link'] = link!;
    if (mirror != null) map['mirror'] = mirror!;
    if (mirror_interval != null) map['mirror_interval'] = mirror_interval!;
    if (mirror_updated != null) map['mirror_updated'] = mirror_updated!.toIso8601String();
    if (name != null) map['name'] = name!;
    if (object_format_name != null) map['object_format_name'] = object_format_name!;
    if (open_issues_count != null) map['open_issues_count'] = open_issues_count!;
    if (open_pr_counter != null) map['open_pr_counter'] = open_pr_counter!;
    if (original_url != null) map['original_url'] = original_url!;
    if (owner != null) map['owner'] = owner!.toJson();
    if (parent != null) map['parent'] = parent!.toJson();
    if (permissions != null) map['permissions'] = permissions!.toJson();
    if (private != null) map['private'] = private!;
    if (projects_mode != null) map['projects_mode'] = projects_mode!;
    if (release_counter != null) map['release_counter'] = release_counter!;
    if (repo_transfer != null) map['repo_transfer'] = repo_transfer!.toJson();
    if (size != null) map['size'] = size!;
    if (ssh_url != null) map['ssh_url'] = ssh_url!;
    if (stars_count != null) map['stars_count'] = stars_count!;
    if (template != null) map['template'] = template!;
    if (topics != null) map['topics'] = topics!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (url != null) map['url'] = url!;
    if (watchers_count != null) map['watchers_count'] = watchers_count!;
    if (website != null) map['website'] = website!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Repository &&
          allow_fast_forward_only_merge == other.allow_fast_forward_only_merge &&
          allow_manual_merge == other.allow_manual_merge &&
          allow_merge_commits == other.allow_merge_commits &&
          allow_rebase == other.allow_rebase &&
          allow_rebase_explicit == other.allow_rebase_explicit &&
          allow_rebase_update == other.allow_rebase_update &&
          allow_squash_merge == other.allow_squash_merge &&
          archived == other.archived &&
          archived_at == other.archived_at &&
          autodetect_manual_merge == other.autodetect_manual_merge &&
          avatar_url == other.avatar_url &&
          clone_url == other.clone_url &&
          created_at == other.created_at &&
          default_allow_maintainer_edit == other.default_allow_maintainer_edit &&
          default_branch == other.default_branch &&
          default_delete_branch_after_merge == other.default_delete_branch_after_merge &&
          default_merge_style == other.default_merge_style &&
          description == other.description &&
          empty == other.empty &&
          external_tracker == other.external_tracker &&
          external_wiki == other.external_wiki &&
          fork == other.fork &&
          forks_count == other.forks_count &&
          full_name == other.full_name &&
          has_actions == other.has_actions &&
          has_code == other.has_code &&
          has_issues == other.has_issues &&
          has_packages == other.has_packages &&
          has_projects == other.has_projects &&
          has_pull_requests == other.has_pull_requests &&
          has_releases == other.has_releases &&
          has_wiki == other.has_wiki &&
          html_url == other.html_url &&
          id == other.id &&
          ignore_whitespace_conflicts == other.ignore_whitespace_conflicts &&
          internal == other.internal &&
          internal_tracker == other.internal_tracker &&
          language == other.language &&
          languages_url == other.languages_url &&
          licenses == other.licenses &&
          link == other.link &&
          mirror == other.mirror &&
          mirror_interval == other.mirror_interval &&
          mirror_updated == other.mirror_updated &&
          name == other.name &&
          object_format_name == other.object_format_name &&
          open_issues_count == other.open_issues_count &&
          open_pr_counter == other.open_pr_counter &&
          original_url == other.original_url &&
          owner == other.owner &&
          parent == other.parent &&
          permissions == other.permissions &&
          private == other.private &&
          projects_mode == other.projects_mode &&
          release_counter == other.release_counter &&
          repo_transfer == other.repo_transfer &&
          size == other.size &&
          ssh_url == other.ssh_url &&
          stars_count == other.stars_count &&
          template == other.template &&
          topics == other.topics &&
          updated_at == other.updated_at &&
          url == other.url &&
          watchers_count == other.watchers_count &&
          website == other.website;
  @override
  int get hashCode => Object.hashAll([allow_fast_forward_only_merge, allow_manual_merge, allow_merge_commits, allow_rebase, allow_rebase_explicit, allow_rebase_update, allow_squash_merge, archived, archived_at, autodetect_manual_merge, avatar_url, clone_url, created_at, default_allow_maintainer_edit, default_branch, default_delete_branch_after_merge, default_merge_style, description, empty, external_tracker, external_wiki, fork, forks_count, full_name, has_actions, has_code, has_issues, has_packages, has_projects, has_pull_requests, has_releases, has_wiki, html_url, id, ignore_whitespace_conflicts, internal, internal_tracker, language, languages_url, licenses, link, mirror, mirror_interval, mirror_updated, name, object_format_name, open_issues_count, open_pr_counter, original_url, owner, parent, permissions, private, projects_mode, release_counter, repo_transfer, size, ssh_url, stars_count, template, topics, updated_at, url, watchers_count, website]);
  @override
  String toString() => 'Repository(allow_fast_forward_only_merge: $allow_fast_forward_only_merge, allow_manual_merge: $allow_manual_merge, allow_merge_commits: $allow_merge_commits, allow_rebase: $allow_rebase, allow_rebase_explicit: $allow_rebase_explicit, allow_rebase_update: $allow_rebase_update, allow_squash_merge: $allow_squash_merge, archived: $archived, archived_at: $archived_at, autodetect_manual_merge: $autodetect_manual_merge, avatar_url: $avatar_url, clone_url: $clone_url, created_at: $created_at, default_allow_maintainer_edit: $default_allow_maintainer_edit, default_branch: $default_branch, default_delete_branch_after_merge: $default_delete_branch_after_merge, default_merge_style: $default_merge_style, description: $description, empty: $empty, external_tracker: $external_tracker, external_wiki: $external_wiki, fork: $fork, forks_count: $forks_count, full_name: $full_name, has_actions: $has_actions, has_code: $has_code, has_issues: $has_issues, has_packages: $has_packages, has_projects: $has_projects, has_pull_requests: $has_pull_requests, has_releases: $has_releases, has_wiki: $has_wiki, html_url: $html_url, id: $id, ignore_whitespace_conflicts: $ignore_whitespace_conflicts, internal: $internal, internal_tracker: $internal_tracker, language: $language, languages_url: $languages_url, licenses: $licenses, link: $link, mirror: $mirror, mirror_interval: $mirror_interval, mirror_updated: $mirror_updated, name: $name, object_format_name: $object_format_name, open_issues_count: $open_issues_count, open_pr_counter: $open_pr_counter, original_url: $original_url, owner: $owner, parent: $parent, permissions: $permissions, private: $private, projects_mode: $projects_mode, release_counter: $release_counter, repo_transfer: $repo_transfer, size: $size, ssh_url: $ssh_url, stars_count: $stars_count, template: $template, topics: $topics, updated_at: $updated_at, url: $url, watchers_count: $watchers_count, website: $website)';
}
