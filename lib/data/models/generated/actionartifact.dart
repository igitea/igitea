part of 'generated_models.dart';

/// ActionArtifact represents a ActionArtifact
class ActionArtifact {
  final String? archive_download_url;
  final DateTime? created_at;
  final bool? expired;
  final DateTime? expires_at;
  final int? id;
  final String? name;
  final int? size_in_bytes;
  final DateTime? updated_at;
  final String? url;
  final ActionWorkflowRun? workflow_run;
  const ActionArtifact({
    this.archive_download_url,
    this.created_at,
    this.expired,
    this.expires_at,
    this.id,
    this.name,
    this.size_in_bytes,
    this.updated_at,
    this.url,
    this.workflow_run,
  });
  factory ActionArtifact.fromJson(Map<String, dynamic> json) {
    return ActionArtifact(
      archive_download_url: json['archive_download_url'] != null
          ? json['archive_download_url'] as String
          : null,
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      expired: json['expired'] != null ? json['expired'] as bool : null,
      expires_at: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      name: json['name'] != null ? json['name'] as String : null,
      size_in_bytes: json['size_in_bytes'] != null
          ? (json['size_in_bytes'] as num).toInt()
          : null,
      updated_at: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      url: json['url'] != null ? json['url'] as String : null,
      workflow_run: json['workflow_run'] != null
          ? ActionWorkflowRun.fromJson(
              json['workflow_run'] as Map<String, dynamic>,
            )
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (archive_download_url != null)
      map['archive_download_url'] = archive_download_url!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (expired != null) map['expired'] = expired!;
    if (expires_at != null) map['expires_at'] = expires_at!.toIso8601String();
    if (id != null) map['id'] = id!;
    if (name != null) map['name'] = name!;
    if (size_in_bytes != null) map['size_in_bytes'] = size_in_bytes!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (url != null) map['url'] = url!;
    if (workflow_run != null) map['workflow_run'] = workflow_run!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionArtifact &&
          archive_download_url == other.archive_download_url &&
          created_at == other.created_at &&
          expired == other.expired &&
          expires_at == other.expires_at &&
          id == other.id &&
          name == other.name &&
          size_in_bytes == other.size_in_bytes &&
          updated_at == other.updated_at &&
          url == other.url &&
          workflow_run == other.workflow_run;
  @override
  int get hashCode => Object.hash(
    archive_download_url,
    created_at,
    expired,
    expires_at,
    id,
    name,
    size_in_bytes,
    updated_at,
    url,
    workflow_run,
  );
  @override
  String toString() =>
      'ActionArtifact(archive_download_url: $archive_download_url, created_at: $created_at, expired: $expired, expires_at: $expires_at, id: $id, name: $name, size_in_bytes: $size_in_bytes, updated_at: $updated_at, url: $url, workflow_run: $workflow_run)';
}
