part of 'generated_models.dart';

/// CreatePullReviewOptions are options to create a pull review
class CreatePullReviewOptions {
  final String? body;
  final List<CreatePullReviewComment>? comments;
  final String? commit_id;
  final ReviewStateType? event;
  const CreatePullReviewOptions({
    this.body,
    this.comments,
    this.commit_id,
    this.event,
  });
  factory CreatePullReviewOptions.fromJson(Map<String, dynamic> json) {
    return CreatePullReviewOptions(
      body: json['body'] != null ? json['body'] as String : null,
      comments: json['comments'] != null
          ? (json['comments'] as List<dynamic>)
                .map(
                  (e) => CreatePullReviewComment.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
      commit_id: json['commit_id'] != null ? json['commit_id'] as String : null,
      event: json['event'] != null
          ? ReviewStateType.fromJson(json['event'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (body != null) map['body'] = body!;
    if (comments != null)
      map['comments'] = comments!.map((e) => e.toJson()).toList();
    if (commit_id != null) map['commit_id'] = commit_id!;
    if (event != null) map['event'] = event!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreatePullReviewOptions &&
          body == other.body &&
          comments == other.comments &&
          commit_id == other.commit_id &&
          event == other.event;
  @override
  int get hashCode => Object.hash(body, comments, commit_id, event);
  @override
  String toString() =>
      'CreatePullReviewOptions(body: $body, comments: $comments, commit_id: $commit_id, event: $event)';
}
