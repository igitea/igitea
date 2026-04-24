part of 'generated_models.dart';

/// PullReviewComment represents a comment on a pull request review
class PullReviewComment {
  final String? body;
  final String? commit_id;
  final DateTime? created_at;
  final String? diff_hunk;
  final String? html_url;
  final int? id;
  final String? original_commit_id;
  final int? original_position;
  final String? path;
  final int? position;
  final int? pull_request_review_id;
  final String? pull_request_url;
  final User? resolver;
  final DateTime? updated_at;
  final User? user;
  const PullReviewComment({
    this.body,
    this.commit_id,
    this.created_at,
    this.diff_hunk,
    this.html_url,
    this.id,
    this.original_commit_id,
    this.original_position,
    this.path,
    this.position,
    this.pull_request_review_id,
    this.pull_request_url,
    this.resolver,
    this.updated_at,
    this.user,
  });
  factory PullReviewComment.fromJson(Map<String, dynamic> json) {
    return PullReviewComment(
      body: json['body'] != null ? json['body'] as String : null,
      commit_id: json['commit_id'] != null ? json['commit_id'] as String : null,
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      diff_hunk: json['diff_hunk'] != null ? json['diff_hunk'] as String : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      original_commit_id: json['original_commit_id'] != null
          ? json['original_commit_id'] as String
          : null,
      original_position: json['original_position'] != null
          ? (json['original_position'] as num).toInt()
          : null,
      path: json['path'] != null ? json['path'] as String : null,
      position: json['position'] != null
          ? (json['position'] as num).toInt()
          : null,
      pull_request_review_id: json['pull_request_review_id'] != null
          ? (json['pull_request_review_id'] as num).toInt()
          : null,
      pull_request_url: json['pull_request_url'] != null
          ? json['pull_request_url'] as String
          : null,
      resolver: json['resolver'] != null
          ? User.fromJson(json['resolver'] as Map<String, dynamic>)
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
    if (commit_id != null) map['commit_id'] = commit_id!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (diff_hunk != null) map['diff_hunk'] = diff_hunk!;
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (original_commit_id != null)
      map['original_commit_id'] = original_commit_id!;
    if (original_position != null)
      map['original_position'] = original_position!;
    if (path != null) map['path'] = path!;
    if (position != null) map['position'] = position!;
    if (pull_request_review_id != null)
      map['pull_request_review_id'] = pull_request_review_id!;
    if (pull_request_url != null) map['pull_request_url'] = pull_request_url!;
    if (resolver != null) map['resolver'] = resolver!.toJson();
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (user != null) map['user'] = user!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PullReviewComment &&
          body == other.body &&
          commit_id == other.commit_id &&
          created_at == other.created_at &&
          diff_hunk == other.diff_hunk &&
          html_url == other.html_url &&
          id == other.id &&
          original_commit_id == other.original_commit_id &&
          original_position == other.original_position &&
          path == other.path &&
          position == other.position &&
          pull_request_review_id == other.pull_request_review_id &&
          pull_request_url == other.pull_request_url &&
          resolver == other.resolver &&
          updated_at == other.updated_at &&
          user == other.user;
  @override
  int get hashCode => Object.hash(
    body,
    commit_id,
    created_at,
    diff_hunk,
    html_url,
    id,
    original_commit_id,
    original_position,
    path,
    position,
    pull_request_review_id,
    pull_request_url,
    resolver,
    updated_at,
    user,
  );
  @override
  String toString() =>
      'PullReviewComment(body: $body, commit_id: $commit_id, created_at: $created_at, diff_hunk: $diff_hunk, html_url: $html_url, id: $id, original_commit_id: $original_commit_id, original_position: $original_position, path: $path, position: $position, pull_request_review_id: $pull_request_review_id, pull_request_url: $pull_request_url, resolver: $resolver, updated_at: $updated_at, user: $user)';
}
