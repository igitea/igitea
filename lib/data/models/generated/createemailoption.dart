part of 'generated_models.dart';

/// CreateEmailOption options when creating email addresses
class CreateEmailOption {
  final List<String>? emails;
  const CreateEmailOption({this.emails});
  factory CreateEmailOption.fromJson(Map<String, dynamic> json) {
    return CreateEmailOption(
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
      other is CreateEmailOption && emails == other.emails;
  @override
  int get hashCode => emails.hashCode;
  @override
  String toString() => 'CreateEmailOption(emails: $emails)';
}
