part of 'generated_models.dart';

/// ContentsResponse contains information about a repo's entry's (dir, file, symlink, submodule) metadata and content
class ContentsResponse {
  final FileLinksResponse? links;
  final String? content;
  final String? download_url;
  final String? encoding;
  final String? git_url;
  final String? html_url;
  final DateTime? last_author_date;
  final String? last_commit_message;
  final String? last_commit_sha;
  final DateTime? last_committer_date;
  final String? lfs_oid;
  final int? lfs_size;
  final String? name;
  final String? path;
  final String? sha;
  final int? size;
  final String? submodule_git_url;
  final String? target;
  final String? type;
  final String? url;
  const ContentsResponse({
    this.links,
    this.content,
    this.download_url,
    this.encoding,
    this.git_url,
    this.html_url,
    this.last_author_date,
    this.last_commit_message,
    this.last_commit_sha,
    this.last_committer_date,
    this.lfs_oid,
    this.lfs_size,
    this.name,
    this.path,
    this.sha,
    this.size,
    this.submodule_git_url,
    this.target,
    this.type,
    this.url,
  });
  factory ContentsResponse.fromJson(Map<String, dynamic> json) {
    return ContentsResponse(
      links: json['_links'] != null
          ? FileLinksResponse.fromJson(json['_links'] as Map<String, dynamic>)
          : null,
      content: json['content'] != null ? json['content'] as String : null,
      download_url: json['download_url'] != null
          ? json['download_url'] as String
          : null,
      encoding: json['encoding'] != null ? json['encoding'] as String : null,
      git_url: json['git_url'] != null ? json['git_url'] as String : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      last_author_date: json['last_author_date'] != null
          ? DateTime.parse(json['last_author_date'] as String)
          : null,
      last_commit_message: json['last_commit_message'] != null
          ? json['last_commit_message'] as String
          : null,
      last_commit_sha: json['last_commit_sha'] != null
          ? json['last_commit_sha'] as String
          : null,
      last_committer_date: json['last_committer_date'] != null
          ? DateTime.parse(json['last_committer_date'] as String)
          : null,
      lfs_oid: json['lfs_oid'] != null ? json['lfs_oid'] as String : null,
      lfs_size: json['lfs_size'] != null
          ? (json['lfs_size'] as num).toInt()
          : null,
      name: json['name'] != null ? json['name'] as String : null,
      path: json['path'] != null ? json['path'] as String : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
      size: json['size'] != null ? (json['size'] as num).toInt() : null,
      submodule_git_url: json['submodule_git_url'] != null
          ? json['submodule_git_url'] as String
          : null,
      target: json['target'] != null ? json['target'] as String : null,
      type: json['type'] != null ? json['type'] as String : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (links != null) map['_links'] = links!.toJson();
    if (content != null) map['content'] = content!;
    if (download_url != null) map['download_url'] = download_url!;
    if (encoding != null) map['encoding'] = encoding!;
    if (git_url != null) map['git_url'] = git_url!;
    if (html_url != null) map['html_url'] = html_url!;
    if (last_author_date != null)
      map['last_author_date'] = last_author_date!.toIso8601String();
    if (last_commit_message != null)
      map['last_commit_message'] = last_commit_message!;
    if (last_commit_sha != null) map['last_commit_sha'] = last_commit_sha!;
    if (last_committer_date != null)
      map['last_committer_date'] = last_committer_date!.toIso8601String();
    if (lfs_oid != null) map['lfs_oid'] = lfs_oid!;
    if (lfs_size != null) map['lfs_size'] = lfs_size!;
    if (name != null) map['name'] = name!;
    if (path != null) map['path'] = path!;
    if (sha != null) map['sha'] = sha!;
    if (size != null) map['size'] = size!;
    if (submodule_git_url != null)
      map['submodule_git_url'] = submodule_git_url!;
    if (target != null) map['target'] = target!;
    if (type != null) map['type'] = type!;
    if (url != null) map['url'] = url!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentsResponse &&
          links == other.links &&
          content == other.content &&
          download_url == other.download_url &&
          encoding == other.encoding &&
          git_url == other.git_url &&
          html_url == other.html_url &&
          last_author_date == other.last_author_date &&
          last_commit_message == other.last_commit_message &&
          last_commit_sha == other.last_commit_sha &&
          last_committer_date == other.last_committer_date &&
          lfs_oid == other.lfs_oid &&
          lfs_size == other.lfs_size &&
          name == other.name &&
          path == other.path &&
          sha == other.sha &&
          size == other.size &&
          submodule_git_url == other.submodule_git_url &&
          target == other.target &&
          type == other.type &&
          url == other.url;
  @override
  int get hashCode => Object.hash(
    links,
    content,
    download_url,
    encoding,
    git_url,
    html_url,
    last_author_date,
    last_commit_message,
    last_commit_sha,
    last_committer_date,
    lfs_oid,
    lfs_size,
    name,
    path,
    sha,
    size,
    submodule_git_url,
    target,
    type,
    url,
  );
  @override
  String toString() =>
      'ContentsResponse(links: $links, content: $content, download_url: $download_url, encoding: $encoding, git_url: $git_url, html_url: $html_url, last_author_date: $last_author_date, last_commit_message: $last_commit_message, last_commit_sha: $last_commit_sha, last_committer_date: $last_committer_date, lfs_oid: $lfs_oid, lfs_size: $lfs_size, name: $name, path: $path, sha: $sha, size: $size, submodule_git_url: $submodule_git_url, target: $target, type: $type, url: $url)';
}
