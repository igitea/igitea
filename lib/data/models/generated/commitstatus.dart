part of 'generated_models.dart';

/// CommitStatus holds a single status of a single Commit
class CommitStatus {
  final String? context;
  final DateTime? created_at;
  final User? creator;
  final String? description;
  final int? id;
  final String? status;
  final String? target_url;
  final DateTime? updated_at;
  final String? url;
  const CommitStatus({
    this.context,
    this.created_at,
    this.creator,
    this.description,
    this.id,
    this.status,
    this.target_url,
    this.updated_at,
    this.url,
  });
  factory CommitStatus.fromJson(Map<String, dynamic> json) {
    return CommitStatus(
      context: json['context'] != null ? json['context'] as String : null,
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      creator: json['creator'] != null
          ? User.fromJson(json['creator'] as Map<String, dynamic>)
          : null,
      description: json['description'] != null
          ? json['description'] as String
          : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      status: json['status'] != null ? json['status'] as String : null,
      target_url: json['target_url'] != null
          ? json['target_url'] as String
          : null,
      updated_at: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (context != null) map['context'] = context!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (creator != null) map['creator'] = creator!.toJson();
    if (description != null) map['description'] = description!;
    if (id != null) map['id'] = id!;
    if (status != null) map['status'] = status!;
    if (target_url != null) map['target_url'] = target_url!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (url != null) map['url'] = url!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommitStatus &&
          context == other.context &&
          created_at == other.created_at &&
          creator == other.creator &&
          description == other.description &&
          id == other.id &&
          status == other.status &&
          target_url == other.target_url &&
          updated_at == other.updated_at &&
          url == other.url;
  @override
  int get hashCode => Object.hash(
    context,
    created_at,
    creator,
    description,
    id,
    status,
    target_url,
    updated_at,
    url,
  );
  @override
  String toString() =>
      'CommitStatus(context: $context, created_at: $created_at, creator: $creator, description: $description, id: $id, status: $status, target_url: $target_url, updated_at: $updated_at, url: $url)';
}
