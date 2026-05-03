part of 'generated_models.dart';

/// ActionWorkflowJob represents a WorkflowJob
class ActionWorkflowJob {
  final DateTime? completed_at;
  final String? conclusion;
  final DateTime? created_at;
  final String? head_branch;
  final String? head_sha;
  final String? html_url;
  final int? id;
  final List<String>? labels;
  final String? name;
  final int? run_attempt;
  final int? run_id;
  final String? run_url;
  final int? runner_id;
  final String? runner_name;
  final DateTime? started_at;
  final String? status;
  final List<ActionWorkflowStep>? steps;
  final String? url;
  const ActionWorkflowJob({
    this.completed_at,
    this.conclusion,
    this.created_at,
    this.head_branch,
    this.head_sha,
    this.html_url,
    this.id,
    this.labels,
    this.name,
    this.run_attempt,
    this.run_id,
    this.run_url,
    this.runner_id,
    this.runner_name,
    this.started_at,
    this.status,
    this.steps,
    this.url,
  });
  factory ActionWorkflowJob.fromJson(Map<String, dynamic> json) {
    return ActionWorkflowJob(
      completed_at: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      conclusion: json['conclusion'] != null ? json['conclusion'] as String : null,
      created_at: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      head_branch: json['head_branch'] != null ? json['head_branch'] as String : null,
      head_sha: json['head_sha'] != null ? json['head_sha'] as String : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      labels: json['labels'] != null ? (json['labels'] as List<dynamic>).cast<String>() : null,
      name: json['name'] != null ? json['name'] as String : null,
      run_attempt: json['run_attempt'] != null ? (json['run_attempt'] as num).toInt() : null,
      run_id: json['run_id'] != null ? (json['run_id'] as num).toInt() : null,
      run_url: json['run_url'] != null ? json['run_url'] as String : null,
      runner_id: json['runner_id'] != null ? (json['runner_id'] as num).toInt() : null,
      runner_name: json['runner_name'] != null ? json['runner_name'] as String : null,
      started_at: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      status: json['status'] != null ? json['status'] as String : null,
      steps: json['steps'] != null ? (json['steps'] as List<dynamic>).map((e) => ActionWorkflowStep.fromJson(e as Map<String, dynamic>)).toList() : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (completed_at != null) map['completed_at'] = completed_at!.toIso8601String();
    if (conclusion != null) map['conclusion'] = conclusion!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (head_branch != null) map['head_branch'] = head_branch!;
    if (head_sha != null) map['head_sha'] = head_sha!;
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (labels != null) map['labels'] = labels!;
    if (name != null) map['name'] = name!;
    if (run_attempt != null) map['run_attempt'] = run_attempt!;
    if (run_id != null) map['run_id'] = run_id!;
    if (run_url != null) map['run_url'] = run_url!;
    if (runner_id != null) map['runner_id'] = runner_id!;
    if (runner_name != null) map['runner_name'] = runner_name!;
    if (started_at != null) map['started_at'] = started_at!.toIso8601String();
    if (status != null) map['status'] = status!;
    if (steps != null) map['steps'] = steps!.map((e) => e.toJson()).toList();
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionWorkflowJob &&
          completed_at == other.completed_at &&
          conclusion == other.conclusion &&
          created_at == other.created_at &&
          head_branch == other.head_branch &&
          head_sha == other.head_sha &&
          html_url == other.html_url &&
          id == other.id &&
          labels == other.labels &&
          name == other.name &&
          run_attempt == other.run_attempt &&
          run_id == other.run_id &&
          run_url == other.run_url &&
          runner_id == other.runner_id &&
          runner_name == other.runner_name &&
          started_at == other.started_at &&
          status == other.status &&
          steps == other.steps &&
          url == other.url;
  @override
  int get hashCode => Object.hash(completed_at, conclusion, created_at, head_branch, head_sha, html_url, id, labels, name, run_attempt, run_id, run_url, runner_id, runner_name, started_at, status, steps, url);
  @override
  String toString() => 'ActionWorkflowJob(completed_at: $completed_at, conclusion: $conclusion, created_at: $created_at, head_branch: $head_branch, head_sha: $head_sha, html_url: $html_url, id: $id, labels: $labels, name: $name, run_attempt: $run_attempt, run_id: $run_id, run_url: $run_url, runner_id: $runner_id, runner_name: $runner_name, started_at: $started_at, status: $status, steps: $steps, url: $url)';
}
