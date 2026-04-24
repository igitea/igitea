part of 'generated_models.dart';

/// ActionWorkflowRun represents a WorkflowRun
class ActionWorkflowRun {
  final User? actor;
  final DateTime? completed_at;
  final String? conclusion;
  final String? display_title;
  final String? event;
  final String? head_branch;
  final Repository? head_repository;
  final String? head_sha;
  final String? html_url;
  final int? id;
  final String? path;
  final Repository? repository;
  final int? repository_id;
  final int? run_attempt;
  final int? run_number;
  final DateTime? started_at;
  final String? status;
  final User? trigger_actor;
  final String? url;
  const ActionWorkflowRun({
    this.actor,
    this.completed_at,
    this.conclusion,
    this.display_title,
    this.event,
    this.head_branch,
    this.head_repository,
    this.head_sha,
    this.html_url,
    this.id,
    this.path,
    this.repository,
    this.repository_id,
    this.run_attempt,
    this.run_number,
    this.started_at,
    this.status,
    this.trigger_actor,
    this.url,
  });
  factory ActionWorkflowRun.fromJson(Map<String, dynamic> json) {
    return ActionWorkflowRun(
      actor: json['actor'] != null
          ? User.fromJson(json['actor'] as Map<String, dynamic>)
          : null,
      completed_at: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      conclusion: json['conclusion'] != null
          ? json['conclusion'] as String
          : null,
      display_title: json['display_title'] != null
          ? json['display_title'] as String
          : null,
      event: json['event'] != null ? json['event'] as String : null,
      head_branch: json['head_branch'] != null
          ? json['head_branch'] as String
          : null,
      head_repository: json['head_repository'] != null
          ? Repository.fromJson(json['head_repository'] as Map<String, dynamic>)
          : null,
      head_sha: json['head_sha'] != null ? json['head_sha'] as String : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      path: json['path'] != null ? json['path'] as String : null,
      repository: json['repository'] != null
          ? Repository.fromJson(json['repository'] as Map<String, dynamic>)
          : null,
      repository_id: json['repository_id'] != null
          ? (json['repository_id'] as num).toInt()
          : null,
      run_attempt: json['run_attempt'] != null
          ? (json['run_attempt'] as num).toInt()
          : null,
      run_number: json['run_number'] != null
          ? (json['run_number'] as num).toInt()
          : null,
      started_at: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      status: json['status'] != null ? json['status'] as String : null,
      trigger_actor: json['trigger_actor'] != null
          ? User.fromJson(json['trigger_actor'] as Map<String, dynamic>)
          : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (actor != null) map['actor'] = actor!.toJson();
    if (completed_at != null)
      map['completed_at'] = completed_at!.toIso8601String();
    if (conclusion != null) map['conclusion'] = conclusion!;
    if (display_title != null) map['display_title'] = display_title!;
    if (event != null) map['event'] = event!;
    if (head_branch != null) map['head_branch'] = head_branch!;
    if (head_repository != null)
      map['head_repository'] = head_repository!.toJson();
    if (head_sha != null) map['head_sha'] = head_sha!;
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (path != null) map['path'] = path!;
    if (repository != null) map['repository'] = repository!.toJson();
    if (repository_id != null) map['repository_id'] = repository_id!;
    if (run_attempt != null) map['run_attempt'] = run_attempt!;
    if (run_number != null) map['run_number'] = run_number!;
    if (started_at != null) map['started_at'] = started_at!.toIso8601String();
    if (status != null) map['status'] = status!;
    if (trigger_actor != null) map['trigger_actor'] = trigger_actor!.toJson();
    if (url != null) map['url'] = url!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionWorkflowRun &&
          actor == other.actor &&
          completed_at == other.completed_at &&
          conclusion == other.conclusion &&
          display_title == other.display_title &&
          event == other.event &&
          head_branch == other.head_branch &&
          head_repository == other.head_repository &&
          head_sha == other.head_sha &&
          html_url == other.html_url &&
          id == other.id &&
          path == other.path &&
          repository == other.repository &&
          repository_id == other.repository_id &&
          run_attempt == other.run_attempt &&
          run_number == other.run_number &&
          started_at == other.started_at &&
          status == other.status &&
          trigger_actor == other.trigger_actor &&
          url == other.url;
  @override
  int get hashCode => Object.hash(
    actor,
    completed_at,
    conclusion,
    display_title,
    event,
    head_branch,
    head_repository,
    head_sha,
    html_url,
    id,
    path,
    repository,
    repository_id,
    run_attempt,
    run_number,
    started_at,
    status,
    trigger_actor,
    url,
  );
  @override
  String toString() =>
      'ActionWorkflowRun(actor: $actor, completed_at: $completed_at, conclusion: $conclusion, display_title: $display_title, event: $event, head_branch: $head_branch, head_repository: $head_repository, head_sha: $head_sha, html_url: $html_url, id: $id, path: $path, repository: $repository, repository_id: $repository_id, run_attempt: $run_attempt, run_number: $run_number, started_at: $started_at, status: $status, trigger_actor: $trigger_actor, url: $url)';
}
