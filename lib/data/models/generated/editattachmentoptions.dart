part of 'generated_models.dart';

/// EditAttachmentOptions options for editing attachments
class EditAttachmentOptions {
  final String? name;
  const EditAttachmentOptions({this.name});
  factory EditAttachmentOptions.fromJson(Map<String, dynamic> json) {
    return EditAttachmentOptions(
      name: json['name'] != null ? json['name'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditAttachmentOptions && name == other.name;
  @override
  int get hashCode => name.hashCode;
  @override
  String toString() => 'EditAttachmentOptions(name: $name)';
}
