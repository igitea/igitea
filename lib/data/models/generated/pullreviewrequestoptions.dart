part of 'generated_models.dart';

/// PullReviewRequestOptions are options to add or remove pull review requests
class PullReviewRequestOptions {
  final List<String>? reviewers;
  final List<String>? team_reviewers;
  const PullReviewRequestOptions({this.reviewers, this.team_reviewers});
  factory PullReviewRequestOptions.fromJson(Map<String, dynamic> json) {
    return PullReviewRequestOptions(
      reviewers: json['reviewers'] != null
          ? (json['reviewers'] as List<dynamic>).cast<String>()
          : null,
      team_reviewers: json['team_reviewers'] != null
          ? (json['team_reviewers'] as List<dynamic>).cast<String>()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (reviewers != null) map['reviewers'] = reviewers!;
    if (team_reviewers != null) map['team_reviewers'] = team_reviewers!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PullReviewRequestOptions &&
          reviewers == other.reviewers &&
          team_reviewers == other.team_reviewers;
  @override
  int get hashCode => Object.hash(reviewers, team_reviewers);
  @override
  String toString() =>
      'PullReviewRequestOptions(reviewers: $reviewers, team_reviewers: $team_reviewers)';
}
