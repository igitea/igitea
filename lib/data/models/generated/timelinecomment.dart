part of 'generated_models.dart';

/// TimelineComment represents a timeline comment (comment of any type) on a commit or issue
class TimelineComment {
  final User? assignee;
  final Team? assignee_team;
  final String? body;
  final DateTime? created_at;
  final Issue? dependent_issue;
  final String? html_url;
  final int? id;
  final String? issue_url;
  final Label? label;
  final Milestone? milestone;
  final String? new_ref;
  final String? new_title;
  final Milestone? old_milestone;
  final int? old_project_id;
  final String? old_ref;
  final String? old_title;
  final int? project_id;
  final String? pull_request_url;
  final String? ref_action;
  final Comment? ref_comment;
  final String? ref_commit_sha;
  final Issue? ref_issue;
  final bool? removed_assignee;
  final User? resolve_doer;
  final int? review_id;
  final TrackedTime? tracked_time;
  final String? type;
  final DateTime? updated_at;
  final User? user;
  const TimelineComment({
    this.assignee,
    this.assignee_team,
    this.body,
    this.created_at,
    this.dependent_issue,
    this.html_url,
    this.id,
    this.issue_url,
    this.label,
    this.milestone,
    this.new_ref,
    this.new_title,
    this.old_milestone,
    this.old_project_id,
    this.old_ref,
    this.old_title,
    this.project_id,
    this.pull_request_url,
    this.ref_action,
    this.ref_comment,
    this.ref_commit_sha,
    this.ref_issue,
    this.removed_assignee,
    this.resolve_doer,
    this.review_id,
    this.tracked_time,
    this.type,
    this.updated_at,
    this.user,
  });
  factory TimelineComment.fromJson(Map<String, dynamic> json) {
    return TimelineComment(
      assignee: json['assignee'] != null
          ? User.fromJson(json['assignee'] as Map<String, dynamic>)
          : null,
      assignee_team: json['assignee_team'] != null
          ? Team.fromJson(json['assignee_team'] as Map<String, dynamic>)
          : null,
      body: json['body'] != null ? json['body'] as String : null,
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      dependent_issue: json['dependent_issue'] != null
          ? Issue.fromJson(json['dependent_issue'] as Map<String, dynamic>)
          : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      issue_url: json['issue_url'] != null ? json['issue_url'] as String : null,
      label: json['label'] != null
          ? Label.fromJson(json['label'] as Map<String, dynamic>)
          : null,
      milestone: json['milestone'] != null
          ? Milestone.fromJson(json['milestone'] as Map<String, dynamic>)
          : null,
      new_ref: json['new_ref'] != null ? json['new_ref'] as String : null,
      new_title: json['new_title'] != null ? json['new_title'] as String : null,
      old_milestone: json['old_milestone'] != null
          ? Milestone.fromJson(json['old_milestone'] as Map<String, dynamic>)
          : null,
      old_project_id: json['old_project_id'] != null
          ? (json['old_project_id'] as num).toInt()
          : null,
      old_ref: json['old_ref'] != null ? json['old_ref'] as String : null,
      old_title: json['old_title'] != null ? json['old_title'] as String : null,
      project_id: json['project_id'] != null
          ? (json['project_id'] as num).toInt()
          : null,
      pull_request_url: json['pull_request_url'] != null
          ? json['pull_request_url'] as String
          : null,
      ref_action: json['ref_action'] != null
          ? json['ref_action'] as String
          : null,
      ref_comment: json['ref_comment'] != null
          ? Comment.fromJson(json['ref_comment'] as Map<String, dynamic>)
          : null,
      ref_commit_sha: json['ref_commit_sha'] != null
          ? json['ref_commit_sha'] as String
          : null,
      ref_issue: json['ref_issue'] != null
          ? Issue.fromJson(json['ref_issue'] as Map<String, dynamic>)
          : null,
      removed_assignee: json['removed_assignee'] != null
          ? json['removed_assignee'] as bool
          : null,
      resolve_doer: json['resolve_doer'] != null
          ? User.fromJson(json['resolve_doer'] as Map<String, dynamic>)
          : null,
      review_id: json['review_id'] != null
          ? (json['review_id'] as num).toInt()
          : null,
      tracked_time: json['tracked_time'] != null
          ? TrackedTime.fromJson(json['tracked_time'] as Map<String, dynamic>)
          : null,
      type: json['type'] != null ? json['type'] as String : null,
      updated_at: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (assignee != null) map['assignee'] = assignee!.toJson();
    if (assignee_team != null) map['assignee_team'] = assignee_team!.toJson();
    if (body != null) map['body'] = body!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (dependent_issue != null)
      map['dependent_issue'] = dependent_issue!.toJson();
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (issue_url != null) map['issue_url'] = issue_url!;
    if (label != null) map['label'] = label!.toJson();
    if (milestone != null) map['milestone'] = milestone!.toJson();
    if (new_ref != null) map['new_ref'] = new_ref!;
    if (new_title != null) map['new_title'] = new_title!;
    if (old_milestone != null) map['old_milestone'] = old_milestone!.toJson();
    if (old_project_id != null) map['old_project_id'] = old_project_id!;
    if (old_ref != null) map['old_ref'] = old_ref!;
    if (old_title != null) map['old_title'] = old_title!;
    if (project_id != null) map['project_id'] = project_id!;
    if (pull_request_url != null) map['pull_request_url'] = pull_request_url!;
    if (ref_action != null) map['ref_action'] = ref_action!;
    if (ref_comment != null) map['ref_comment'] = ref_comment!.toJson();
    if (ref_commit_sha != null) map['ref_commit_sha'] = ref_commit_sha!;
    if (ref_issue != null) map['ref_issue'] = ref_issue!.toJson();
    if (removed_assignee != null) map['removed_assignee'] = removed_assignee!;
    if (resolve_doer != null) map['resolve_doer'] = resolve_doer!.toJson();
    if (review_id != null) map['review_id'] = review_id!;
    if (tracked_time != null) map['tracked_time'] = tracked_time!.toJson();
    if (type != null) map['type'] = type!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (user != null) map['user'] = user!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelineComment &&
          assignee == other.assignee &&
          assignee_team == other.assignee_team &&
          body == other.body &&
          created_at == other.created_at &&
          dependent_issue == other.dependent_issue &&
          html_url == other.html_url &&
          id == other.id &&
          issue_url == other.issue_url &&
          label == other.label &&
          milestone == other.milestone &&
          new_ref == other.new_ref &&
          new_title == other.new_title &&
          old_milestone == other.old_milestone &&
          old_project_id == other.old_project_id &&
          old_ref == other.old_ref &&
          old_title == other.old_title &&
          project_id == other.project_id &&
          pull_request_url == other.pull_request_url &&
          ref_action == other.ref_action &&
          ref_comment == other.ref_comment &&
          ref_commit_sha == other.ref_commit_sha &&
          ref_issue == other.ref_issue &&
          removed_assignee == other.removed_assignee &&
          resolve_doer == other.resolve_doer &&
          review_id == other.review_id &&
          tracked_time == other.tracked_time &&
          type == other.type &&
          updated_at == other.updated_at &&
          user == other.user;
  @override
  int get hashCode => Object.hashAll([
    assignee,
    assignee_team,
    body,
    created_at,
    dependent_issue,
    html_url,
    id,
    issue_url,
    label,
    milestone,
    new_ref,
    new_title,
    old_milestone,
    old_project_id,
    old_ref,
    old_title,
    project_id,
    pull_request_url,
    ref_action,
    ref_comment,
    ref_commit_sha,
    ref_issue,
    removed_assignee,
    resolve_doer,
    review_id,
    tracked_time,
    type,
    updated_at,
    user,
  ]);
  @override
  String toString() =>
      'TimelineComment(assignee: $assignee, assignee_team: $assignee_team, body: $body, created_at: $created_at, dependent_issue: $dependent_issue, html_url: $html_url, id: $id, issue_url: $issue_url, label: $label, milestone: $milestone, new_ref: $new_ref, new_title: $new_title, old_milestone: $old_milestone, old_project_id: $old_project_id, old_ref: $old_ref, old_title: $old_title, project_id: $project_id, pull_request_url: $pull_request_url, ref_action: $ref_action, ref_comment: $ref_comment, ref_commit_sha: $ref_commit_sha, ref_issue: $ref_issue, removed_assignee: $removed_assignee, resolve_doer: $resolve_doer, review_id: $review_id, tracked_time: $tracked_time, type: $type, updated_at: $updated_at, user: $user)';
}
