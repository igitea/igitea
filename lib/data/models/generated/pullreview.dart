part of 'generated_models.dart';

/// PullReview represents a pull request review
class PullReview {
  final String? body;
  final int? comments_count;
  final String? commit_id;
  final bool? dismissed;
  final String? html_url;
  final int? id;
  final bool? official;
  final String? pull_request_url;
  final bool? stale;
  final ReviewStateType? state;
  final DateTime? submitted_at;
  final Team? team;
  final DateTime? updated_at;
  final User? user;
  const PullReview({
    this.body,
    this.comments_count,
    this.commit_id,
    this.dismissed,
    this.html_url,
    this.id,
    this.official,
    this.pull_request_url,
    this.stale,
    this.state,
    this.submitted_at,
    this.team,
    this.updated_at,
    this.user,
  });
  factory PullReview.fromJson(Map<String, dynamic> json) {
    return PullReview(
      body: json['body'] != null ? json['body'] as String : null,
      comments_count: json['comments_count'] != null
          ? (json['comments_count'] as num).toInt()
          : null,
      commit_id: json['commit_id'] != null ? json['commit_id'] as String : null,
      dismissed: json['dismissed'] != null ? json['dismissed'] as bool : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      official: json['official'] != null ? json['official'] as bool : null,
      pull_request_url: json['pull_request_url'] != null
          ? json['pull_request_url'] as String
          : null,
      stale: json['stale'] != null ? json['stale'] as bool : null,
      state: json['state'] != null
          ? ReviewStateType.fromJson(json['state'] as Map<String, dynamic>)
          : null,
      submitted_at: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'] as String)
          : null,
      team: json['team'] != null
          ? Team.fromJson(json['team'] as Map<String, dynamic>)
          : null,
      updated_at: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (body != null) map['body'] = body!;
    if (comments_count != null) map['comments_count'] = comments_count!;
    if (commit_id != null) map['commit_id'] = commit_id!;
    if (dismissed != null) map['dismissed'] = dismissed!;
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (official != null) map['official'] = official!;
    if (pull_request_url != null) map['pull_request_url'] = pull_request_url!;
    if (stale != null) map['stale'] = stale!;
    if (state != null) map['state'] = state!.toJson();
    if (submitted_at != null)
      map['submitted_at'] = submitted_at!.toIso8601String();
    if (team != null) map['team'] = team!.toJson();
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (user != null) map['user'] = user!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PullReview &&
          body == other.body &&
          comments_count == other.comments_count &&
          commit_id == other.commit_id &&
          dismissed == other.dismissed &&
          html_url == other.html_url &&
          id == other.id &&
          official == other.official &&
          pull_request_url == other.pull_request_url &&
          stale == other.stale &&
          state == other.state &&
          submitted_at == other.submitted_at &&
          team == other.team &&
          updated_at == other.updated_at &&
          user == other.user;
  @override
  int get hashCode => Object.hash(
    body,
    comments_count,
    commit_id,
    dismissed,
    html_url,
    id,
    official,
    pull_request_url,
    stale,
    state,
    submitted_at,
    team,
    updated_at,
    user,
  );
  @override
  String toString() =>
      'PullReview(body: $body, comments_count: $comments_count, commit_id: $commit_id, dismissed: $dismissed, html_url: $html_url, id: $id, official: $official, pull_request_url: $pull_request_url, stale: $stale, state: $state, submitted_at: $submitted_at, team: $team, updated_at: $updated_at, user: $user)';
}
