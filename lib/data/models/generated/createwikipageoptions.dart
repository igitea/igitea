part of 'generated_models.dart';

/// CreateWikiPageOptions form for creating wiki
class CreateWikiPageOptions {
  final String? content_base64;
  final String? message;
  final String? title;
  const CreateWikiPageOptions({
    this.content_base64,
    this.message,
    this.title,
  });
  factory CreateWikiPageOptions.fromJson(Map<String, dynamic> json) {
    return CreateWikiPageOptions(
      content_base64: json['content_base64'] != null ? json['content_base64'] as String : null,
      message: json['message'] != null ? json['message'] as String : null,
      title: json['title'] != null ? json['title'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (content_base64 != null) map['content_base64'] = content_base64!;
    if (message != null) map['message'] = message!;
    if (title != null) map['title'] = title!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateWikiPageOptions &&
          content_base64 == other.content_base64 &&
          message == other.message &&
          title == other.title;
  @override
  int get hashCode => Object.hash(content_base64, message, title);
  @override
  String toString() => 'CreateWikiPageOptions(content_base64: $content_base64, message: $message, title: $title)';
}
