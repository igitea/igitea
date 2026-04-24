part of 'generated_models.dart';

/// Release represents a repository release
class Release {
  final List<Attachment>? assets;
  final User? author;
  final String? body;
  final DateTime? created_at;
  final bool? draft;
  final String? html_url;
  final int? id;
  final String? name;
  final bool? prerelease;
  final DateTime? published_at;
  final String? tag_name;
  final String? tarball_url;
  final String? target_commitish;
  final String? upload_url;
  final String? url;
  final String? zipball_url;
  const Release({
    this.assets,
    this.author,
    this.body,
    this.created_at,
    this.draft,
    this.html_url,
    this.id,
    this.name,
    this.prerelease,
    this.published_at,
    this.tag_name,
    this.tarball_url,
    this.target_commitish,
    this.upload_url,
    this.url,
    this.zipball_url,
  });
  factory Release.fromJson(Map<String, dynamic> json) {
    return Release(
      assets: json['assets'] != null
          ? (json['assets'] as List<dynamic>)
                .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      author: json['author'] != null
          ? User.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      body: json['body'] != null ? json['body'] as String : null,
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      draft: json['draft'] != null ? json['draft'] as bool : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      name: json['name'] != null ? json['name'] as String : null,
      prerelease: json['prerelease'] != null
          ? json['prerelease'] as bool
          : null,
      published_at: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      tag_name: json['tag_name'] != null ? json['tag_name'] as String : null,
      tarball_url: json['tarball_url'] != null
          ? json['tarball_url'] as String
          : null,
      target_commitish: json['target_commitish'] != null
          ? json['target_commitish'] as String
          : null,
      upload_url: json['upload_url'] != null
          ? json['upload_url'] as String
          : null,
      url: json['url'] != null ? json['url'] as String : null,
      zipball_url: json['zipball_url'] != null
          ? json['zipball_url'] as String
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (assets != null) map['assets'] = assets!.map((e) => e.toJson()).toList();
    if (author != null) map['author'] = author!.toJson();
    if (body != null) map['body'] = body!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (draft != null) map['draft'] = draft!;
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (name != null) map['name'] = name!;
    if (prerelease != null) map['prerelease'] = prerelease!;
    if (published_at != null)
      map['published_at'] = published_at!.toIso8601String();
    if (tag_name != null) map['tag_name'] = tag_name!;
    if (tarball_url != null) map['tarball_url'] = tarball_url!;
    if (target_commitish != null) map['target_commitish'] = target_commitish!;
    if (upload_url != null) map['upload_url'] = upload_url!;
    if (url != null) map['url'] = url!;
    if (zipball_url != null) map['zipball_url'] = zipball_url!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Release &&
          assets == other.assets &&
          author == other.author &&
          body == other.body &&
          created_at == other.created_at &&
          draft == other.draft &&
          html_url == other.html_url &&
          id == other.id &&
          name == other.name &&
          prerelease == other.prerelease &&
          published_at == other.published_at &&
          tag_name == other.tag_name &&
          tarball_url == other.tarball_url &&
          target_commitish == other.target_commitish &&
          upload_url == other.upload_url &&
          url == other.url &&
          zipball_url == other.zipball_url;
  @override
  int get hashCode => Object.hash(
    assets,
    author,
    body,
    created_at,
    draft,
    html_url,
    id,
    name,
    prerelease,
    published_at,
    tag_name,
    tarball_url,
    target_commitish,
    upload_url,
    url,
    zipball_url,
  );
  @override
  String toString() =>
      'Release(assets: $assets, author: $author, body: $body, created_at: $created_at, draft: $draft, html_url: $html_url, id: $id, name: $name, prerelease: $prerelease, published_at: $published_at, tag_name: $tag_name, tarball_url: $tarball_url, target_commitish: $target_commitish, upload_url: $upload_url, url: $url, zipball_url: $zipball_url)';
}
