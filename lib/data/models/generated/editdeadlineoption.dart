part of 'generated_models.dart';

/// EditDeadlineOption options for creating a deadline
class EditDeadlineOption {
  final DateTime? due_date;
  const EditDeadlineOption({this.due_date});
  factory EditDeadlineOption.fromJson(Map<String, dynamic> json) {
    return EditDeadlineOption(
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
      other is EditDeadlineOption && due_date == other.due_date;
  @override
  int get hashCode => due_date.hashCode;
  @override
  String toString() => 'EditDeadlineOption(due_date: $due_date)';
}
