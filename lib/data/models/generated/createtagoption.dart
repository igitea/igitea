part of 'generated_models.dart';

/// CreateTagOption options when creating a tag
class CreateTagOption {
  final String? message;
  final String? tag_name;
  final String? target;
  const CreateTagOption({this.message, this.tag_name, this.target});
  factory CreateTagOption.fromJson(Map<String, dynamic> json) {
    return CreateTagOption(
      message: json['message'] != null ? json['message'] as String : null,
      tag_name: json['tag_name'] != null ? json['tag_name'] as String : null,
      target: json['target'] != null ? json['target'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (message != null) map['message'] = message!;
    if (tag_name != null) map['tag_name'] = tag_name!;
    if (target != null) map['target'] = target!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateTagOption &&
          message == other.message &&
          tag_name == other.tag_name &&
          target == other.target;
  @override
  int get hashCode => Object.hash(message, tag_name, target);
  @override
  String toString() =>
      'CreateTagOption(message: $message, tag_name: $tag_name, target: $target)';
}
