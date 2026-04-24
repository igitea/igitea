part of 'generated_models.dart';

/// TopicResponse for returning topics
class TopicResponse {
  final DateTime? created;
  final int? id;
  final int? repo_count;
  final String? topic_name;
  final DateTime? updated;
  const TopicResponse({
    this.created,
    this.id,
    this.repo_count,
    this.topic_name,
    this.updated,
  });
  factory TopicResponse.fromJson(Map<String, dynamic> json) {
    return TopicResponse(
      created: json['created'] != null
          ? DateTime.parse(json['created'] as String)
          : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      repo_count: json['repo_count'] != null
          ? (json['repo_count'] as num).toInt()
          : null,
      topic_name: json['topic_name'] != null
          ? json['topic_name'] as String
          : null,
      updated: json['updated'] != null
          ? DateTime.parse(json['updated'] as String)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created != null) map['created'] = created!.toIso8601String();
    if (id != null) map['id'] = id!;
    if (repo_count != null) map['repo_count'] = repo_count!;
    if (topic_name != null) map['topic_name'] = topic_name!;
    if (updated != null) map['updated'] = updated!.toIso8601String();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicResponse &&
          created == other.created &&
          id == other.id &&
          repo_count == other.repo_count &&
          topic_name == other.topic_name &&
          updated == other.updated;
  @override
  int get hashCode => Object.hash(created, id, repo_count, topic_name, updated);
  @override
  String toString() =>
      'TopicResponse(created: $created, id: $id, repo_count: $repo_count, topic_name: $topic_name, updated: $updated)';
}
