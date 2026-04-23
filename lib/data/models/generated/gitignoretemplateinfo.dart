part of 'generated_models.dart';

/// GitignoreTemplateInfo name and text of a gitignore template
class GitignoreTemplateInfo {
  final String? name;
  final String? source;
  const GitignoreTemplateInfo({
    this.name,
    this.source,
  });
  factory GitignoreTemplateInfo.fromJson(Map<String, dynamic> json) {
    return GitignoreTemplateInfo(
      name: json['name'] != null ? json['name'] as String : null,
      source: json['source'] != null ? json['source'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name!;
    if (source != null) map['source'] = source!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitignoreTemplateInfo &&
          name == other.name &&
          source == other.source;
  @override
  int get hashCode => Object.hash(name, source);
  @override
  String toString() => 'GitignoreTemplateInfo(name: $name, source: $source)';
}
