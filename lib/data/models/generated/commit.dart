part of 'generated_models.dart';

/// Commit contains information generated from a Git commit.
class Commit {
  final User? author;
  final RepoCommit? commit;
  final User? committer;
  final DateTime? created;
  final List<CommitAffectedFiles>? files;
  final String? html_url;
  final List<CommitMeta>? parents;
  final String? sha;
  final CommitStats? stats;
  final String? url;
  const Commit({
    this.author,
    this.commit,
    this.committer,
    this.created,
    this.files,
    this.html_url,
    this.parents,
    this.sha,
    this.stats,
    this.url,
  });
  factory Commit.fromJson(Map<String, dynamic> json) {
    return Commit(
      author: json['author'] != null
          ? User.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      commit: json['commit'] != null
          ? RepoCommit.fromJson(json['commit'] as Map<String, dynamic>)
          : null,
      committer: json['committer'] != null
          ? User.fromJson(json['committer'] as Map<String, dynamic>)
          : null,
      created: json['created'] != null
          ? DateTime.parse(json['created'] as String)
          : null,
      files: json['files'] != null
          ? (json['files'] as List<dynamic>)
                .map(
                  (e) =>
                      CommitAffectedFiles.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      parents: json['parents'] != null
          ? (json['parents'] as List<dynamic>)
                .map((e) => CommitMeta.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
      stats: json['stats'] != null
          ? CommitStats.fromJson(json['stats'] as Map<String, dynamic>)
          : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (author != null) map['author'] = author!.toJson();
    if (commit != null) map['commit'] = commit!.toJson();
    if (committer != null) map['committer'] = committer!.toJson();
    if (created != null) map['created'] = created!.toIso8601String();
    if (files != null) map['files'] = files!.map((e) => e.toJson()).toList();
    if (html_url != null) map['html_url'] = html_url!;
    if (parents != null)
      map['parents'] = parents!.map((e) => e.toJson()).toList();
    if (sha != null) map['sha'] = sha!;
    if (stats != null) map['stats'] = stats!.toJson();
    if (url != null) map['url'] = url!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Commit &&
          author == other.author &&
          commit == other.commit &&
          committer == other.committer &&
          created == other.created &&
          files == other.files &&
          html_url == other.html_url &&
          parents == other.parents &&
          sha == other.sha &&
          stats == other.stats &&
          url == other.url;
  @override
  int get hashCode => Object.hash(
    author,
    commit,
    committer,
    created,
    files,
    html_url,
    parents,
    sha,
    stats,
    url,
  );
  @override
  String toString() =>
      'Commit(author: $author, commit: $commit, committer: $committer, created: $created, files: $files, html_url: $html_url, parents: $parents, sha: $sha, stats: $stats, url: $url)';
}
