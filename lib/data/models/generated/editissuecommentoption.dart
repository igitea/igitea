part of 'generated_models.dart';

/// EditIssueCommentOption options for editing a comment
class EditIssueCommentOption {
  final String? body;
  const EditIssueCommentOption({this.body});
  factory EditIssueCommentOption.fromJson(Map<String, dynamic> json) {
    return EditIssueCommentOption(
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
      other is EditIssueCommentOption && body == other.body;
  @override
  int get hashCode => body.hashCode;
  @override
  String toString() => 'EditIssueCommentOption(body: $body)';
}
