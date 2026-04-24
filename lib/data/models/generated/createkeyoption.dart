part of 'generated_models.dart';

/// CreateKeyOption options when creating a key
class CreateKeyOption {
  final String? key;
  final bool? read_only;
  final String? title;
  const CreateKeyOption({this.key, this.read_only, this.title});
  factory CreateKeyOption.fromJson(Map<String, dynamic> json) {
    return CreateKeyOption(
      key: json['key'] != null ? json['key'] as String : null,
      read_only: json['read_only'] != null ? json['read_only'] as bool : null,
      title: json['title'] != null ? json['title'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (key != null) map['key'] = key!;
    if (read_only != null) map['read_only'] = read_only!;
    if (title != null) map['title'] = title!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateKeyOption &&
          key == other.key &&
          read_only == other.read_only &&
          title == other.title;
  @override
  int get hashCode => Object.hash(key, read_only, title);
  @override
  String toString() =>
      'CreateKeyOption(key: $key, read_only: $read_only, title: $title)';
}
