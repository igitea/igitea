part of 'generated_models.dart';

/// CreateIssueOption options to create one issue
class CreateIssueOption {
  final String? assignee;
  final List<String>? assignees;
  final String? body;
  final bool? closed;
  final DateTime? due_date;
  final List<int>? labels;
  final int? milestone;
  final String? ref;
  final String? title;
  const CreateIssueOption({
    this.assignee,
    this.assignees,
    this.body,
    this.closed,
    this.due_date,
    this.labels,
    this.milestone,
    this.ref,
    this.title,
  });
  factory CreateIssueOption.fromJson(Map<String, dynamic> json) {
    return CreateIssueOption(
      assignee: json['assignee'] != null ? json['assignee'] as String : null,
      assignees: json['assignees'] != null
          ? (json['assignees'] as List<dynamic>).cast<String>()
          : null,
      body: json['body'] != null ? json['body'] as String : null,
      closed: json['closed'] != null ? json['closed'] as bool : null,
      due_date: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      labels: json['labels'] != null
          ? (json['labels'] as List<dynamic>)
                .map((e) => (e as num).toInt())
                .toList()
          : null,
      milestone: json['milestone'] != null
          ? (json['milestone'] as num).toInt()
          : null,
      ref: json['ref'] != null ? json['ref'] as String : null,
      title: json['title'] != null ? json['title'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (assignee != null) map['assignee'] = assignee!;
    if (assignees != null) map['assignees'] = assignees!;
    if (body != null) map['body'] = body!;
    if (closed != null) map['closed'] = closed!;
    if (due_date != null) map['due_date'] = due_date!.toIso8601String();
    if (labels != null) map['labels'] = labels!;
    if (milestone != null) map['milestone'] = milestone!;
    if (ref != null) map['ref'] = ref!;
    if (title != null) map['title'] = title!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateIssueOption &&
          assignee == other.assignee &&
          assignees == other.assignees &&
          body == other.body &&
          closed == other.closed &&
          due_date == other.due_date &&
          labels == other.labels &&
          milestone == other.milestone &&
          ref == other.ref &&
          title == other.title;
  @override
  int get hashCode => Object.hash(
    assignee,
    assignees,
    body,
    closed,
    due_date,
    labels,
    milestone,
    ref,
    title,
  );
  @override
  String toString() =>
      'CreateIssueOption(assignee: $assignee, assignees: $assignees, body: $body, closed: $closed, due_date: $due_date, labels: $labels, milestone: $milestone, ref: $ref, title: $title)';
}
