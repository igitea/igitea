part of 'generated_models.dart';

/// CreatePullReviewComment represent a review comment for creation api
class CreatePullReviewComment {
  final String? body;
  final int? new_position;
  final int? old_position;
  final String? path;
  const CreatePullReviewComment({
    this.body,
    this.new_position,
    this.old_position,
    this.path,
  });
  factory CreatePullReviewComment.fromJson(Map<String, dynamic> json) {
    return CreatePullReviewComment(
      body: json['body'] != null ? json['body'] as String : null,
      new_position: json['new_position'] != null ? (json['new_position'] as num).toInt() : null,
      old_position: json['old_position'] != null ? (json['old_position'] as num).toInt() : null,
      path: json['path'] != null ? json['path'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (body != null) map['body'] = body!;
    if (new_position != null) map['new_position'] = new_position!;
    if (old_position != null) map['old_position'] = old_position!;
    if (path != null) map['path'] = path!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreatePullReviewComment &&
          body == other.body &&
          new_position == other.new_position &&
          old_position == other.old_position &&
          path == other.path;
  @override
  int get hashCode => Object.hash(body, new_position, old_position, path);
  @override
  String toString() => 'CreatePullReviewComment(body: $body, new_position: $new_position, old_position: $old_position, path: $path)';
}
