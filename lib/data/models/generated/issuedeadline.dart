part of 'generated_models.dart';

/// IssueDeadline represents an issue deadline
class IssueDeadline {
  final DateTime? due_date;
  const IssueDeadline({this.due_date});
  factory IssueDeadline.fromJson(Map<String, dynamic> json) {
    return IssueDeadline(
      due_date: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (due_date != null) map['due_date'] = due_date!.toIso8601String();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueDeadline && due_date == other.due_date;
  @override
  int get hashCode => due_date.hashCode;
  @override
  String toString() => 'IssueDeadline(due_date: $due_date)';
}
