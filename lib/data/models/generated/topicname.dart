part of 'generated_models.dart';

/// TopicName a list of repo topic names
class TopicName {
  final List<String>? topics;
  const TopicName({this.topics});
  factory TopicName.fromJson(Map<String, dynamic> json) {
    return TopicName(
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
      identical(this, other) || other is TopicName && topics == other.topics;
  @override
  int get hashCode => topics.hashCode;
  @override
  String toString() => 'TopicName(topics: $topics)';
}
