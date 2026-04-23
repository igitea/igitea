part of 'generated_models.dart';

/// CreateIssueCommentOption options for creating a comment on an issue
class CreateIssueCommentOption {
  final String? body;
  const CreateIssueCommentOption({
    this.body,
  });
  factory CreateIssueCommentOption.fromJson(Map<String, dynamic> json) {
    return CreateIssueCommentOption(
      body: json['body'] != null ? json['body'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (body != null) map['body'] = body!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateIssueCommentOption &&
          body == other.body;
  @override
  int get hashCode => body.hashCode;
  @override
  String toString() => 'CreateIssueCommentOption(body: $body)';
}
