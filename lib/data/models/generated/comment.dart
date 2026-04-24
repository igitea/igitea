part of 'generated_models.dart';

/// Comment represents a comment on a commit or issue
class Comment {
  final List<Attachment>? assets;
  final String? body;
  final DateTime? created_at;
  final String? html_url;
  final int? id;
  final String? issue_url;
  final String? original_author;
  final int? original_author_id;
  final String? pull_request_url;
  final DateTime? updated_at;
  final User? user;
  const Comment({
    this.assets,
    this.body,
    this.created_at,
    this.html_url,
    this.id,
    this.issue_url,
    this.original_author,
    this.original_author_id,
    this.pull_request_url,
    this.updated_at,
    this.user,
  });
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      assets: json['assets'] != null
          ? (json['assets'] as List<dynamic>)
                .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      body: json['body'] != null ? json['body'] as String : null,
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      issue_url: json['issue_url'] != null ? json['issue_url'] as String : null,
      original_author: json['original_author'] != null
          ? json['original_author'] as String
          : null,
      original_author_id: json['original_author_id'] != null
          ? (json['original_author_id'] as num).toInt()
          : null,
      pull_request_url: json['pull_request_url'] != null
          ? json['pull_request_url'] as String
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
    if (assets != null) map['assets'] = assets!.map((e) => e.toJson()).toList();
    if (body != null) map['body'] = body!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (issue_url != null) map['issue_url'] = issue_url!;
    if (original_author != null) map['original_author'] = original_author!;
    if (original_author_id != null)
      map['original_author_id'] = original_author_id!;
    if (pull_request_url != null) map['pull_request_url'] = pull_request_url!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (user != null) map['user'] = user!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          assets == other.assets &&
          body == other.body &&
          created_at == other.created_at &&
          html_url == other.html_url &&
          id == other.id &&
          issue_url == other.issue_url &&
          original_author == other.original_author &&
          original_author_id == other.original_author_id &&
          pull_request_url == other.pull_request_url &&
          updated_at == other.updated_at &&
          user == other.user;
  @override
  int get hashCode => Object.hash(
    assets,
    body,
    created_at,
    html_url,
    id,
    issue_url,
    original_author,
    original_author_id,
    pull_request_url,
    updated_at,
    user,
  );
  @override
  String toString() =>
      'Comment(assets: $assets, body: $body, created_at: $created_at, html_url: $html_url, id: $id, issue_url: $issue_url, original_author: $original_author, original_author_id: $original_author_id, pull_request_url: $pull_request_url, updated_at: $updated_at, user: $user)';
}
