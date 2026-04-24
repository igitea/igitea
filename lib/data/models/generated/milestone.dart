part of 'generated_models.dart';

/// Milestone milestone is a collection of issues on one repository
class Milestone {
  final DateTime? closed_at;
  final int? closed_issues;
  final DateTime? created_at;
  final String? description;
  final DateTime? due_on;
  final int? id;
  final int? open_issues;
  final StateType? state;
  final String? title;
  final DateTime? updated_at;
  const Milestone({
    this.closed_at,
    this.closed_issues,
    this.created_at,
    this.description,
    this.due_on,
    this.id,
    this.open_issues,
    this.state,
    this.title,
    this.updated_at,
  });
  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      closed_at: json['closed_at'] != null
          ? DateTime.parse(json['closed_at'] as String)
          : null,
      closed_issues: json['closed_issues'] != null
          ? (json['closed_issues'] as num).toInt()
          : null,
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      description: json['description'] != null
          ? json['description'] as String
          : null,
      due_on: json['due_on'] != null
          ? DateTime.parse(json['due_on'] as String)
          : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      open_issues: json['open_issues'] != null
          ? (json['open_issues'] as num).toInt()
          : null,
      state: json['state'] != null
          ? StateType.fromJson(json['state'])
          : null,
      title: json['title'] != null ? json['title'] as String : null,
      updated_at: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (closed_at != null) map['closed_at'] = closed_at!.toIso8601String();
    if (closed_issues != null) map['closed_issues'] = closed_issues!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (description != null) map['description'] = description!;
    if (due_on != null) map['due_on'] = due_on!.toIso8601String();
    if (id != null) map['id'] = id!;
    if (open_issues != null) map['open_issues'] = open_issues!;
    if (state != null) map['state'] = state!.toJson();
    if (title != null) map['title'] = title!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Milestone &&
          closed_at == other.closed_at &&
          closed_issues == other.closed_issues &&
          created_at == other.created_at &&
          description == other.description &&
          due_on == other.due_on &&
          id == other.id &&
          open_issues == other.open_issues &&
          state == other.state &&
          title == other.title &&
          updated_at == other.updated_at;
  @override
  int get hashCode => Object.hash(
    closed_at,
    closed_issues,
    created_at,
    description,
    due_on,
    id,
    open_issues,
    state,
    title,
    updated_at,
  );
  @override
  String toString() =>
      'Milestone(closed_at: $closed_at, closed_issues: $closed_issues, created_at: $created_at, description: $description, due_on: $due_on, id: $id, open_issues: $open_issues, state: $state, title: $title, updated_at: $updated_at)';
}
