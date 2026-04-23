part of 'generated_models.dart';

/// EditGitHookOption options when modifying one Git hook
class EditGitHookOption {
  final String? content;
  const EditGitHookOption({
    this.content,
  });
  factory EditGitHookOption.fromJson(Map<String, dynamic> json) {
    return EditGitHookOption(
      content: json['content'] != null ? json['content'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (content != null) map['content'] = content!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditGitHookOption &&
          content == other.content;
  @override
  int get hashCode => content.hashCode;
  @override
  String toString() => 'EditGitHookOption(content: $content)';
}
