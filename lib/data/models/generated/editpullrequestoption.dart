part of 'generated_models.dart';

/// EditPullRequestOption options when modify pull request
class EditPullRequestOption {
  final bool? allow_maintainer_edit;
  final String? assignee;
  final List<String>? assignees;
  final String? base_;
  final String? body;
  final DateTime? due_date;
  final List<int>? labels;
  final int? milestone;
  final String? state;
  final String? title;
  final bool? unset_due_date;
  const EditPullRequestOption({
    this.allow_maintainer_edit,
    this.assignee,
    this.assignees,
    this.base_,
    this.body,
    this.due_date,
    this.labels,
    this.milestone,
    this.state,
    this.title,
    this.unset_due_date,
  });
  factory EditPullRequestOption.fromJson(Map<String, dynamic> json) {
    return EditPullRequestOption(
      allow_maintainer_edit: json['allow_maintainer_edit'] != null ? json['allow_maintainer_edit'] as bool : null,
      assignee: json['assignee'] != null ? json['assignee'] as String : null,
      assignees: json['assignees'] != null ? (json['assignees'] as List<dynamic>).cast<String>() : null,
      base_: json['base'] != null ? json['base'] as String : null,
      body: json['body'] != null ? json['body'] as String : null,
      due_date: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      labels: json['labels'] != null ? (json['labels'] as List<dynamic>).map((e) => (e as num).toInt()).toList() : null,
      milestone: json['milestone'] != null ? (json['milestone'] as num).toInt() : null,
      state: json['state'] != null ? json['state'] as String : null,
      title: json['title'] != null ? json['title'] as String : null,
      unset_due_date: json['unset_due_date'] != null ? json['unset_due_date'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (allow_maintainer_edit != null) map['allow_maintainer_edit'] = allow_maintainer_edit!;
    if (assignee != null) map['assignee'] = assignee!;
    if (assignees != null) map['assignees'] = assignees!;
    if (base_ != null) map['base'] = base_!;
    if (body != null) map['body'] = body!;
    if (due_date != null) map['due_date'] = due_date!.toIso8601String();
    if (labels != null) map['labels'] = labels!;
    if (milestone != null) map['milestone'] = milestone!;
    if (state != null) map['state'] = state!;
    if (title != null) map['title'] = title!;
    if (unset_due_date != null) map['unset_due_date'] = unset_due_date!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditPullRequestOption &&
          allow_maintainer_edit == other.allow_maintainer_edit &&
          assignee == other.assignee &&
          assignees == other.assignees &&
          base_ == other.base_ &&
          body == other.body &&
          due_date == other.due_date &&
          labels == other.labels &&
          milestone == other.milestone &&
          state == other.state &&
          title == other.title &&
          unset_due_date == other.unset_due_date;
  @override
  int get hashCode => Object.hash(allow_maintainer_edit, assignee, assignees, base_, body, due_date, labels, milestone, state, title, unset_due_date);
  @override
  String toString() => 'EditPullRequestOption(allow_maintainer_edit: $allow_maintainer_edit, assignee: $assignee, assignees: $assignees, base_: $base_, body: $body, due_date: $due_date, labels: $labels, milestone: $milestone, state: $state, title: $title, unset_due_date: $unset_due_date)';
}
