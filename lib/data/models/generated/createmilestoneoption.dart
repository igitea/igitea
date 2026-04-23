part of 'generated_models.dart';

/// CreateMilestoneOption options for creating a milestone
class CreateMilestoneOption {
  final String? description;
  final DateTime? due_on;
  final String? state;
  final String? title;
  const CreateMilestoneOption({
    this.description,
    this.due_on,
    this.state,
    this.title,
  });
  factory CreateMilestoneOption.fromJson(Map<String, dynamic> json) {
    return CreateMilestoneOption(
      description: json['description'] != null ? json['description'] as String : null,
      due_on: json['due_on'] != null ? DateTime.parse(json['due_on'] as String) : null,
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
      other is CreateMilestoneOption &&
          description == other.description &&
          due_on == other.due_on &&
          state == other.state &&
          title == other.title;
  @override
  int get hashCode => Object.hash(description, due_on, state, title);
  @override
  String toString() => 'CreateMilestoneOption(description: $description, due_on: $due_on, state: $state, title: $title)';
}
