part of 'generated_models.dart';

/// LockIssueOption options to lock an issue
class LockIssueOption {
  final String? lock_reason;
  const LockIssueOption({this.lock_reason});
  factory LockIssueOption.fromJson(Map<String, dynamic> json) {
    return LockIssueOption(
      lock_reason: json['lock_reason'] != null
          ? json['lock_reason'] as String
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (lock_reason != null) map['lock_reason'] = lock_reason!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LockIssueOption && lock_reason == other.lock_reason;
  @override
  int get hashCode => lock_reason.hashCode;
  @override
  String toString() => 'LockIssueOption(lock_reason: $lock_reason)';
}
