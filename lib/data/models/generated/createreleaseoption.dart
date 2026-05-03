part of 'generated_models.dart';

/// CreateReleaseOption options when creating a release
class CreateReleaseOption {
  final String? body;
  final bool? draft;
  final String? name;
  final bool? prerelease;
  final String? tag_message;
  final String? tag_name;
  final String? target_commitish;
  const CreateReleaseOption({
    this.body,
    this.draft,
    this.name,
    this.prerelease,
    this.tag_message,
    this.tag_name,
    this.target_commitish,
  });
  factory CreateReleaseOption.fromJson(Map<String, dynamic> json) {
    return CreateReleaseOption(
      body: json['body'] != null ? json['body'] as String : null,
      draft: json['draft'] != null ? json['draft'] as bool : null,
      name: json['name'] != null ? json['name'] as String : null,
      prerelease: json['prerelease'] != null ? json['prerelease'] as bool : null,
      tag_message: json['tag_message'] != null ? json['tag_message'] as String : null,
      tag_name: json['tag_name'] != null ? json['tag_name'] as String : null,
      target_commitish: json['target_commitish'] != null ? json['target_commitish'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (body != null) map['body'] = body!;
    if (draft != null) map['draft'] = draft!;
    if (name != null) map['name'] = name!;
    if (prerelease != null) map['prerelease'] = prerelease!;
    if (tag_message != null) map['tag_message'] = tag_message!;
    if (tag_name != null) map['tag_name'] = tag_name!;
    if (target_commitish != null) map['target_commitish'] = target_commitish!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateReleaseOption &&
          body == other.body &&
          draft == other.draft &&
          name == other.name &&
          prerelease == other.prerelease &&
          tag_message == other.tag_message &&
          tag_name == other.tag_name &&
          target_commitish == other.target_commitish;
  @override
  int get hashCode => Object.hash(body, draft, name, prerelease, tag_message, tag_name, target_commitish);
  @override
  String toString() => 'CreateReleaseOption(body: $body, draft: $draft, name: $name, prerelease: $prerelease, tag_message: $tag_message, tag_name: $tag_name, target_commitish: $target_commitish)';
}
