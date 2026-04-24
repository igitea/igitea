part of 'generated_models.dart';

/// EditReactionOption contain the reaction type
class EditReactionOption {
  final String? content;
  const EditReactionOption({this.content});
  factory EditReactionOption.fromJson(Map<String, dynamic> json) {
    return EditReactionOption(
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
      other is EditReactionOption && content == other.content;
  @override
  int get hashCode => content.hashCode;
  @override
  String toString() => 'EditReactionOption(content: $content)';
}
