part of 'generated_models.dart';

/// GitHook represents a Git repository hook
class GitHook {
  final String? content;
  final bool? is_active;
  final String? name;
  const GitHook({
    this.content,
    this.is_active,
    this.name,
  });
  factory GitHook.fromJson(Map<String, dynamic> json) {
    return GitHook(
      content: json['content'] != null ? json['content'] as String : null,
      is_active: json['is_active'] != null ? json['is_active'] as bool : null,
      name: json['name'] != null ? json['name'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (content != null) map['content'] = content!;
    if (is_active != null) map['is_active'] = is_active!;
    if (name != null) map['name'] = name!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitHook &&
          content == other.content &&
          is_active == other.is_active &&
          name == other.name;
  @override
  int get hashCode => Object.hash(content, is_active, name);
  @override
  String toString() => 'GitHook(content: $content, is_active: $is_active, name: $name)';
}
