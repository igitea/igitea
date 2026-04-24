part of 'generated_models.dart';

/// CreatePullRequestOption options when creating a pull request
class CreatePullRequestOption {
  final String? assignee;
  final List<String>? assignees;
  final String? base_;
  final String? body;
  final DateTime? due_date;
  final String? head;
  final List<int>? labels;
  final int? milestone;
  final List<String>? reviewers;
  final List<String>? team_reviewers;
  final String? title;
  const CreatePullRequestOption({
    this.assignee,
    this.assignees,
    this.base_,
    this.body,
    this.due_date,
    this.head,
    this.labels,
    this.milestone,
    this.reviewers,
    this.team_reviewers,
    this.title,
  });
  factory CreatePullRequestOption.fromJson(Map<String, dynamic> json) {
    return CreatePullRequestOption(
      assignee: json['assignee'] != null ? json['assignee'] as String : null,
      assignees: json['assignees'] != null
          ? (json['assignees'] as List<dynamic>).cast<String>()
          : null,
      base_: json['base'] != null ? json['base'] as String : null,
      body: json['body'] != null ? json['body'] as String : null,
      due_date: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      head: json['head'] != null ? json['head'] as String : null,
      labels: json['labels'] != null
          ? (json['labels'] as List<dynamic>)
                .map((e) => (e as num).toInt())
                .toList()
          : null,
      milestone: json['milestone'] != null
          ? (json['milestone'] as num).toInt()
          : null,
      reviewers: json['reviewers'] != null
          ? (json['reviewers'] as List<dynamic>).cast<String>()
          : null,
      team_reviewers: json['team_reviewers'] != null
          ? (json['team_reviewers'] as List<dynamic>).cast<String>()
          : null,
      title: json['title'] != null ? json['title'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (assignee != null) map['assignee'] = assignee!;
    if (assignees != null) map['assignees'] = assignees!;
    if (base_ != null) map['base'] = base_!;
    if (body != null) map['body'] = body!;
    if (due_date != null) map['due_date'] = due_date!.toIso8601String();
    if (head != null) map['head'] = head!;
    if (labels != null) map['labels'] = labels!;
    if (milestone != null) map['milestone'] = milestone!;
    if (reviewers != null) map['reviewers'] = reviewers!;
    if (team_reviewers != null) map['team_reviewers'] = team_reviewers!;
    if (title != null) map['title'] = title!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreatePullRequestOption &&
          assignee == other.assignee &&
          assignees == other.assignees &&
          base_ == other.base_ &&
          body == other.body &&
          due_date == other.due_date &&
          head == other.head &&
          labels == other.labels &&
          milestone == other.milestone &&
          reviewers == other.reviewers &&
          team_reviewers == other.team_reviewers &&
          title == other.title;
  @override
  int get hashCode => Object.hash(
    assignee,
    assignees,
    base_,
    body,
    due_date,
    head,
    labels,
    milestone,
    reviewers,
    team_reviewers,
    title,
  );
  @override
  String toString() =>
      'CreatePullRequestOption(assignee: $assignee, assignees: $assignees, base_: $base_, body: $body, due_date: $due_date, head: $head, labels: $labels, milestone: $milestone, reviewers: $reviewers, team_reviewers: $team_reviewers, title: $title)';
}
