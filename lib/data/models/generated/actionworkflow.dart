part of 'generated_models.dart';

/// ActionWorkflow represents a ActionWorkflow
class ActionWorkflow {
  final String? badge_url;
  final DateTime? created_at;
  final DateTime? deleted_at;
  final String? html_url;
  final String? id;
  final String? name;
  final String? path;
  final String? state;
  final DateTime? updated_at;
  final String? url;
  const ActionWorkflow({
    this.badge_url,
    this.created_at,
    this.deleted_at,
    this.html_url,
    this.id,
    this.name,
    this.path,
    this.state,
    this.updated_at,
    this.url,
  });
  factory ActionWorkflow.fromJson(Map<String, dynamic> json) {
    return ActionWorkflow(
      badge_url: json['badge_url'] != null ? json['badge_url'] as String : null,
      created_at: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      deleted_at: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? json['id'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      path: json['path'] != null ? json['path'] as String : null,
      state: json['state'] != null ? json['state'] as String : null,
      updated_at: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (badge_url != null) map['badge_url'] = badge_url!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (deleted_at != null) map['deleted_at'] = deleted_at!.toIso8601String();
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (name != null) map['name'] = name!;
    if (path != null) map['path'] = path!;
    if (state != null) map['state'] = state!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionWorkflow &&
          badge_url == other.badge_url &&
          created_at == other.created_at &&
          deleted_at == other.deleted_at &&
          html_url == other.html_url &&
          id == other.id &&
          name == other.name &&
          path == other.path &&
          state == other.state &&
          updated_at == other.updated_at &&
          url == other.url;
  @override
  int get hashCode => Object.hash(badge_url, created_at, deleted_at, html_url, id, name, path, state, updated_at, url);
  @override
  String toString() => 'ActionWorkflow(badge_url: $badge_url, created_at: $created_at, deleted_at: $deleted_at, html_url: $html_url, id: $id, name: $name, path: $path, state: $state, updated_at: $updated_at, url: $url)';
}
