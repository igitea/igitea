part of 'generated_models.dart';

/// PullRequest represents a pull request
class PullRequest {
  final int? additions;
  final bool? allow_maintainer_edit;
  final User? assignee;
  final List<User>? assignees;
  final PRBranchInfo? base_;
  final String? body;
  final int? changed_files;
  final DateTime? closed_at;
  final int? comments;
  final DateTime? created_at;
  final int? deletions;
  final String? diff_url;
  final bool? draft;
  final DateTime? due_date;
  final PRBranchInfo? head;
  final String? html_url;
  final int? id;
  final bool? is_locked;
  final List<Label>? labels;
  final String? merge_base;
  final String? merge_commit_sha;
  final bool? mergeable;
  final bool? merged;
  final DateTime? merged_at;
  final User? merged_by;
  final Milestone? milestone;
  final int? number;
  final String? patch_url;
  final int? pin_order;
  final List<User>? requested_reviewers;
  final List<Team>? requested_reviewers_teams;
  final int? review_comments;
  final StateType? state;
  final String? title;
  final DateTime? updated_at;
  final String? url;
  final User? user;
  const PullRequest({
    this.additions,
    this.allow_maintainer_edit,
    this.assignee,
    this.assignees,
    this.base_,
    this.body,
    this.changed_files,
    this.closed_at,
    this.comments,
    this.created_at,
    this.deletions,
    this.diff_url,
    this.draft,
    this.due_date,
    this.head,
    this.html_url,
    this.id,
    this.is_locked,
    this.labels,
    this.merge_base,
    this.merge_commit_sha,
    this.mergeable,
    this.merged,
    this.merged_at,
    this.merged_by,
    this.milestone,
    this.number,
    this.patch_url,
    this.pin_order,
    this.requested_reviewers,
    this.requested_reviewers_teams,
    this.review_comments,
    this.state,
    this.title,
    this.updated_at,
    this.url,
    this.user,
  });
  factory PullRequest.fromJson(Map<String, dynamic> json) {
    return PullRequest(
      additions: json['additions'] != null ? (json['additions'] as num).toInt() : null,
      allow_maintainer_edit: json['allow_maintainer_edit'] != null ? json['allow_maintainer_edit'] as bool : null,
      assignee: json['assignee'] != null ? User.fromJson(json['assignee'] as Map<String, dynamic>) : null,
      assignees: json['assignees'] != null ? (json['assignees'] as List<dynamic>).map((e) => User.fromJson(e as Map<String, dynamic>)).toList() : null,
      base_: json['base'] != null ? PRBranchInfo.fromJson(json['base'] as Map<String, dynamic>) : null,
      body: json['body'] != null ? json['body'] as String : null,
      changed_files: json['changed_files'] != null ? (json['changed_files'] as num).toInt() : null,
      closed_at: json['closed_at'] != null ? DateTime.parse(json['closed_at'] as String) : null,
      comments: json['comments'] != null ? (json['comments'] as num).toInt() : null,
      created_at: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      deletions: json['deletions'] != null ? (json['deletions'] as num).toInt() : null,
      diff_url: json['diff_url'] != null ? json['diff_url'] as String : null,
      draft: json['draft'] != null ? json['draft'] as bool : null,
      due_date: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      head: json['head'] != null ? PRBranchInfo.fromJson(json['head'] as Map<String, dynamic>) : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      is_locked: json['is_locked'] != null ? json['is_locked'] as bool : null,
      labels: json['labels'] != null ? (json['labels'] as List<dynamic>).map((e) => Label.fromJson(e as Map<String, dynamic>)).toList() : null,
      merge_base: json['merge_base'] != null ? json['merge_base'] as String : null,
      merge_commit_sha: json['merge_commit_sha'] != null ? json['merge_commit_sha'] as String : null,
      mergeable: json['mergeable'] != null ? json['mergeable'] as bool : null,
      merged: json['merged'] != null ? json['merged'] as bool : null,
      merged_at: json['merged_at'] != null ? DateTime.parse(json['merged_at'] as String) : null,
      merged_by: json['merged_by'] != null ? User.fromJson(json['merged_by'] as Map<String, dynamic>) : null,
      milestone: json['milestone'] != null ? Milestone.fromJson(json['milestone'] as Map<String, dynamic>) : null,
      number: json['number'] != null ? (json['number'] as num).toInt() : null,
      patch_url: json['patch_url'] != null ? json['patch_url'] as String : null,
      pin_order: json['pin_order'] != null ? (json['pin_order'] as num).toInt() : null,
      requested_reviewers: json['requested_reviewers'] != null ? (json['requested_reviewers'] as List<dynamic>).map((e) => User.fromJson(e as Map<String, dynamic>)).toList() : null,
      requested_reviewers_teams: json['requested_reviewers_teams'] != null ? (json['requested_reviewers_teams'] as List<dynamic>).map((e) => Team.fromJson(e as Map<String, dynamic>)).toList() : null,
      review_comments: json['review_comments'] != null ? (json['review_comments'] as num).toInt() : null,
      state: json['state'] != null ? StateType.fromJson(json['state'] as Map<String, dynamic>) : null,
      title: json['title'] != null ? json['title'] as String : null,
      updated_at: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      url: json['url'] != null ? json['url'] as String : null,
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (additions != null) map['additions'] = additions!;
    if (allow_maintainer_edit != null) map['allow_maintainer_edit'] = allow_maintainer_edit!;
    if (assignee != null) map['assignee'] = assignee!.toJson();
    if (assignees != null) map['assignees'] = assignees!.map((e) => e.toJson()).toList();
    if (base_ != null) map['base'] = base_!.toJson();
    if (body != null) map['body'] = body!;
    if (changed_files != null) map['changed_files'] = changed_files!;
    if (closed_at != null) map['closed_at'] = closed_at!.toIso8601String();
    if (comments != null) map['comments'] = comments!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (deletions != null) map['deletions'] = deletions!;
    if (diff_url != null) map['diff_url'] = diff_url!;
    if (draft != null) map['draft'] = draft!;
    if (due_date != null) map['due_date'] = due_date!.toIso8601String();
    if (head != null) map['head'] = head!.toJson();
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (is_locked != null) map['is_locked'] = is_locked!;
    if (labels != null) map['labels'] = labels!.map((e) => e.toJson()).toList();
    if (merge_base != null) map['merge_base'] = merge_base!;
    if (merge_commit_sha != null) map['merge_commit_sha'] = merge_commit_sha!;
    if (mergeable != null) map['mergeable'] = mergeable!;
    if (merged != null) map['merged'] = merged!;
    if (merged_at != null) map['merged_at'] = merged_at!.toIso8601String();
    if (merged_by != null) map['merged_by'] = merged_by!.toJson();
    if (milestone != null) map['milestone'] = milestone!.toJson();
    if (number != null) map['number'] = number!;
    if (patch_url != null) map['patch_url'] = patch_url!;
    if (pin_order != null) map['pin_order'] = pin_order!;
    if (requested_reviewers != null) map['requested_reviewers'] = requested_reviewers!.map((e) => e.toJson()).toList();
    if (requested_reviewers_teams != null) map['requested_reviewers_teams'] = requested_reviewers_teams!.map((e) => e.toJson()).toList();
    if (review_comments != null) map['review_comments'] = review_comments!;
    if (state != null) map['state'] = state!.toJson();
    if (title != null) map['title'] = title!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (url != null) map['url'] = url!;
    if (user != null) map['user'] = user!.toJson();
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PullRequest &&
          additions == other.additions &&
          allow_maintainer_edit == other.allow_maintainer_edit &&
          assignee == other.assignee &&
          assignees == other.assignees &&
          base_ == other.base_ &&
          body == other.body &&
          changed_files == other.changed_files &&
          closed_at == other.closed_at &&
          comments == other.comments &&
          created_at == other.created_at &&
          deletions == other.deletions &&
          diff_url == other.diff_url &&
          draft == other.draft &&
          due_date == other.due_date &&
          head == other.head &&
          html_url == other.html_url &&
          id == other.id &&
          is_locked == other.is_locked &&
          labels == other.labels &&
          merge_base == other.merge_base &&
          merge_commit_sha == other.merge_commit_sha &&
          mergeable == other.mergeable &&
          merged == other.merged &&
          merged_at == other.merged_at &&
          merged_by == other.merged_by &&
          milestone == other.milestone &&
          number == other.number &&
          patch_url == other.patch_url &&
          pin_order == other.pin_order &&
          requested_reviewers == other.requested_reviewers &&
          requested_reviewers_teams == other.requested_reviewers_teams &&
          review_comments == other.review_comments &&
          state == other.state &&
          title == other.title &&
          updated_at == other.updated_at &&
          url == other.url &&
          user == other.user;
  @override
  int get hashCode => Object.hashAll([additions, allow_maintainer_edit, assignee, assignees, base_, body, changed_files, closed_at, comments, created_at, deletions, diff_url, draft, due_date, head, html_url, id, is_locked, labels, merge_base, merge_commit_sha, mergeable, merged, merged_at, merged_by, milestone, number, patch_url, pin_order, requested_reviewers, requested_reviewers_teams, review_comments, state, title, updated_at, url, user]);
  @override
  String toString() => 'PullRequest(additions: $additions, allow_maintainer_edit: $allow_maintainer_edit, assignee: $assignee, assignees: $assignees, base_: $base_, body: $body, changed_files: $changed_files, closed_at: $closed_at, comments: $comments, created_at: $created_at, deletions: $deletions, diff_url: $diff_url, draft: $draft, due_date: $due_date, head: $head, html_url: $html_url, id: $id, is_locked: $is_locked, labels: $labels, merge_base: $merge_base, merge_commit_sha: $merge_commit_sha, mergeable: $mergeable, merged: $merged, merged_at: $merged_at, merged_by: $merged_by, milestone: $milestone, number: $number, patch_url: $patch_url, pin_order: $pin_order, requested_reviewers: $requested_reviewers, requested_reviewers_teams: $requested_reviewers_teams, review_comments: $review_comments, state: $state, title: $title, updated_at: $updated_at, url: $url, user: $user)';
}
