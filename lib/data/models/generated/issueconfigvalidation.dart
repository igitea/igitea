part of 'generated_models.dart';

class IssueConfigValidation {
  final String? message;
  final bool? valid;
  const IssueConfigValidation({
    this.message,
    this.valid,
  });
  factory IssueConfigValidation.fromJson(Map<String, dynamic> json) {
    return IssueConfigValidation(
      message: json['message'] != null ? json['message'] as String : null,
      valid: json['valid'] != null ? json['valid'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (message != null) map['message'] = message!;
    if (valid != null) map['valid'] = valid!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueConfigValidation &&
          message == other.message &&
          valid == other.valid;
  @override
  int get hashCode => Object.hash(message, valid);
  @override
  String toString() => 'IssueConfigValidation(message: $message, valid: $valid)';
}
