part of 'generated_models.dart';

/// EditIssueOption options for editing an issue
class EditIssueOption {
  final String? assignee;
  final List<String>? assignees;
  final String? body;
  final DateTime? due_date;
  final int? milestone;
  final String? ref;
  final String? state;
  final String? title;
  final bool? unset_due_date;
  const EditIssueOption({
    this.assignee,
    this.assignees,
    this.body,
    this.due_date,
    this.milestone,
    this.ref,
    this.state,
    this.title,
    this.unset_due_date,
  });
  factory EditIssueOption.fromJson(Map<String, dynamic> json) {
    return EditIssueOption(
      assignee: json['assignee'] != null ? json['assignee'] as String : null,
      assignees: json['assignees'] != null
          ? (json['assignees'] as List<dynamic>).cast<String>()
          : null,
      body: json['body'] != null ? json['body'] as String : null,
      due_date: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      milestone: json['milestone'] != null
          ? (json['milestone'] as num).toInt()
          : null,
      ref: json['ref'] != null ? json['ref'] as String : null,
      state: json['state'] != null ? json['state'] as String : null,
      title: json['title'] != null ? json['title'] as String : null,
      unset_due_date: json['unset_due_date'] != null
          ? json['unset_due_date'] as bool
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (assignee != null) map['assignee'] = assignee!;
    if (assignees != null) map['assignees'] = assignees!;
    if (body != null) map['body'] = body!;
    if (due_date != null) map['due_date'] = due_date!.toIso8601String();
    if (milestone != null) map['milestone'] = milestone!;
    if (ref != null) map['ref'] = ref!;
    if (state != null) map['state'] = state!;
    if (title != null) map['title'] = title!;
    if (unset_due_date != null) map['unset_due_date'] = unset_due_date!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditIssueOption &&
          assignee == other.assignee &&
          assignees == other.assignees &&
          body == other.body &&
          due_date == other.due_date &&
          milestone == other.milestone &&
          ref == other.ref &&
          state == other.state &&
          title == other.title &&
          unset_due_date == other.unset_due_date;
  @override
  int get hashCode => Object.hash(
    assignee,
    assignees,
    body,
    due_date,
    milestone,
    ref,
    state,
    title,
    unset_due_date,
  );
  @override
  String toString() =>
      'EditIssueOption(assignee: $assignee, assignees: $assignees, body: $body, due_date: $due_date, milestone: $milestone, ref: $ref, state: $state, title: $title, unset_due_date: $unset_due_date)';
}
