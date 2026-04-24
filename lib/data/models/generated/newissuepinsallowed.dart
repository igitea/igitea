part of 'generated_models.dart';

/// NewIssuePinsAllowed represents an API response that says if new Issue Pins are allowed
class NewIssuePinsAllowed {
  final bool? issues;
  final bool? pull_requests;
  const NewIssuePinsAllowed({this.issues, this.pull_requests});
  factory NewIssuePinsAllowed.fromJson(Map<String, dynamic> json) {
    return NewIssuePinsAllowed(
      issues: json['issues'] != null ? json['issues'] as bool : null,
      pull_requests: json['pull_requests'] != null
          ? json['pull_requests'] as bool
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (issues != null) map['issues'] = issues!;
    if (pull_requests != null) map['pull_requests'] = pull_requests!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewIssuePinsAllowed &&
          issues == other.issues &&
          pull_requests == other.pull_requests;
  @override
  int get hashCode => Object.hash(issues, pull_requests);
  @override
  String toString() =>
      'NewIssuePinsAllowed(issues: $issues, pull_requests: $pull_requests)';
}
