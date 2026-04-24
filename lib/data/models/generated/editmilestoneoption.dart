part of 'generated_models.dart';

/// EditMilestoneOption options for editing a milestone
class EditMilestoneOption {
  final String? description;
  final DateTime? due_on;
  final String? state;
  final String? title;
  const EditMilestoneOption({
    this.description,
    this.due_on,
    this.state,
    this.title,
  });
  factory EditMilestoneOption.fromJson(Map<String, dynamic> json) {
    return EditMilestoneOption(
      description: json['description'] != null
          ? json['description'] as String
          : null,
      due_on: json['due_on'] != null
          ? DateTime.parse(json['due_on'] as String)
          : null,
      state: json['state'] != null ? json['state'] as String : null,
      title: json['title'] != null ? json['title'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (description != null) map['description'] = description!;
    if (due_on != null) map['due_on'] = due_on!.toIso8601String();
    if (state != null) map['state'] = state!;
    if (title != null) map['title'] = title!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditMilestoneOption &&
          description == other.description &&
          due_on == other.due_on &&
          state == other.state &&
          title == other.title;
  @override
  int get hashCode => Object.hash(description, due_on, state, title);
  @override
  String toString() =>
      'EditMilestoneOption(description: $description, due_on: $due_on, state: $state, title: $title)';
}
