part of 'generated_models.dart';

/// RepoTopicOptions a collection of repo topic names
class RepoTopicOptions {
  final List<String>? topics;
  const RepoTopicOptions({this.topics});
  factory RepoTopicOptions.fromJson(Map<String, dynamic> json) {
    return RepoTopicOptions(
      topics: json['topics'] != null
          ? (json['topics'] as List<dynamic>).cast<String>()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (topics != null) map['topics'] = topics!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepoTopicOptions && topics == other.topics;
  @override
  int get hashCode => topics.hashCode;
  @override
  String toString() => 'RepoTopicOptions(topics: $topics)';
}
