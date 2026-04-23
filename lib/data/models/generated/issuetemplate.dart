part of 'generated_models.dart';

/// IssueTemplate represents an issue template for a repository
class IssueTemplate {
  final String? about;
  final IssueTemplateStringSlice? assignees;
  final List<IssueFormField>? body;
  final String? content;
  final String? file_name;
  final IssueTemplateStringSlice? labels;
  final String? name;
  final String? ref;
  final String? title;
  const IssueTemplate({
    this.about,
    this.assignees,
    this.body,
    this.content,
    this.file_name,
    this.labels,
    this.name,
    this.ref,
    this.title,
  });
  factory IssueTemplate.fromJson(Map<String, dynamic> json) {
    return IssueTemplate(
      about: json['about'] != null ? json['about'] as String : null,
      assignees: json['assignees'] != null ? IssueTemplateStringSlice.fromJson(json['assignees'] as Map<String, dynamic>) : null,
      body: json['body'] != null ? (json['body'] as List<dynamic>).map((e) => IssueFormField.fromJson(e as Map<String, dynamic>)).toList() : null,
      content: json['content'] != null ? json['content'] as String : null,
      file_name: json['file_name'] != null ? json['file_name'] as String : null,
      labels: json['labels'] != null ? IssueTemplateStringSlice.fromJson(json['labels'] as Map<String, dynamic>) : null,
      name: json['name'] != null ? json['name'] as String : null,
      ref: json['ref'] != null ? json['ref'] as String : null,
      title: json['title'] != null ? json['title'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (about != null) map['about'] = about!;
    if (assignees != null) map['assignees'] = assignees!.toJson();
    if (body != null) map['body'] = body!.map((e) => e.toJson()).toList();
    if (content != null) map['content'] = content!;
    if (file_name != null) map['file_name'] = file_name!;
    if (labels != null) map['labels'] = labels!.toJson();
    if (name != null) map['name'] = name!;
    if (ref != null) map['ref'] = ref!;
    if (title != null) map['title'] = title!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueTemplate &&
          about == other.about &&
          assignees == other.assignees &&
          body == other.body &&
          content == other.content &&
          file_name == other.file_name &&
          labels == other.labels &&
          name == other.name &&
          ref == other.ref &&
          title == other.title;
  @override
  int get hashCode => Object.hash(about, assignees, body, content, file_name, labels, name, ref, title);
  @override
  String toString() => 'IssueTemplate(about: $about, assignees: $assignees, body: $body, content: $content, file_name: $file_name, labels: $labels, name: $name, ref: $ref, title: $title)';
}
