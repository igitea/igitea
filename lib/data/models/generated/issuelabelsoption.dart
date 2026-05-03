part of 'generated_models.dart';

/// IssueLabelsOption a collection of labels
class IssueLabelsOption {
  final List<dynamic>? labels;
  const IssueLabelsOption({
    this.labels,
  });
  factory IssueLabelsOption.fromJson(Map<String, dynamic> json) {
    return IssueLabelsOption(
      labels: json['labels'] != null ? (json['labels'] as List<dynamic>) : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (labels != null) map['labels'] = labels!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueLabelsOption &&
          labels == other.labels;
  @override
  int get hashCode => labels.hashCode;
  @override
  String toString() => 'IssueLabelsOption(labels: $labels)';
}
