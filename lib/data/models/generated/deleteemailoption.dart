part of 'generated_models.dart';

/// DeleteEmailOption options when deleting email addresses
class DeleteEmailOption {
  final List<String>? emails;
  const DeleteEmailOption({this.emails});
  factory DeleteEmailOption.fromJson(Map<String, dynamic> json) {
    return DeleteEmailOption(
      emails: json['emails'] != null
          ? (json['emails'] as List<dynamic>).cast<String>()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (emails != null) map['emails'] = emails!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteEmailOption && emails == other.emails;
  @override
  int get hashCode => emails.hashCode;
  @override
  String toString() => 'DeleteEmailOption(emails: $emails)';
}
