part of 'generated_models.dart';

/// ActionTask represents a ActionTask
class ActionTask {
  final DateTime? created_at;
  final String? display_title;
  final String? event;
  final String? head_branch;
  final String? head_sha;
  final int? id;
  final String? name;
  final int? run_number;
  final DateTime? run_started_at;
  final String? status;
  final DateTime? updated_at;
  final String? url;
  final String? workflow_id;
  const ActionTask({
    this.created_at,
    this.display_title,
    this.event,
    this.head_branch,
    this.head_sha,
    this.id,
    this.name,
    this.run_number,
    this.run_started_at,
    this.status,
    this.updated_at,
    this.url,
    this.workflow_id,
  });
  factory ActionTask.fromJson(Map<String, dynamic> json) {
    return ActionTask(
      created_at: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      display_title: json['display_title'] != null ? json['display_title'] as String : null,
      event: json['event'] != null ? json['event'] as String : null,
      head_branch: json['head_branch'] != null ? json['head_branch'] as String : null,
      head_sha: json['head_sha'] != null ? json['head_sha'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      name: json['name'] != null ? json['name'] as String : null,
      run_number: json['run_number'] != null ? (json['run_number'] as num).toInt() : null,
      run_started_at: json['run_started_at'] != null ? DateTime.parse(json['run_started_at'] as String) : null,
      status: json['status'] != null ? json['status'] as String : null,
      updated_at: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      url: json['url'] != null ? json['url'] as String : null,
      workflow_id: json['workflow_id'] != null ? json['workflow_id'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (display_title != null) map['display_title'] = display_title!;
    if (event != null) map['event'] = event!;
    if (head_branch != null) map['head_branch'] = head_branch!;
    if (head_sha != null) map['head_sha'] = head_sha!;
    if (id != null) map['id'] = id!;
    if (name != null) map['name'] = name!;
    if (run_number != null) map['run_number'] = run_number!;
    if (run_started_at != null) map['run_started_at'] = run_started_at!.toIso8601String();
    if (status != null) map['status'] = status!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (url != null) map['url'] = url!;
    if (workflow_id != null) map['workflow_id'] = workflow_id!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionTask &&
          created_at == other.created_at &&
          display_title == other.display_title &&
          event == other.event &&
          head_branch == other.head_branch &&
          head_sha == other.head_sha &&
          id == other.id &&
          name == other.name &&
          run_number == other.run_number &&
          run_started_at == other.run_started_at &&
          status == other.status &&
          updated_at == other.updated_at &&
          url == other.url &&
          workflow_id == other.workflow_id;
  @override
  int get hashCode => Object.hash(created_at, display_title, event, head_branch, head_sha, id, name, run_number, run_started_at, status, updated_at, url, workflow_id);
  @override
  String toString() => 'ActionTask(created_at: $created_at, display_title: $display_title, event: $event, head_branch: $head_branch, head_sha: $head_sha, id: $id, name: $name, run_number: $run_number, run_started_at: $run_started_at, status: $status, updated_at: $updated_at, url: $url, workflow_id: $workflow_id)';
}
