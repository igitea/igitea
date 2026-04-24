part of 'generated_models.dart';

/// WikiPage a wiki page
class WikiPage {
  final int? commit_count;
  final String? content_base64;
  final String? footer;
  final String? html_url;
  final WikiCommit? last_commit;
  final String? sidebar;
  final String? sub_url;
  final String? title;
  const WikiPage({
    this.commit_count,
    this.content_base64,
    this.footer,
    this.html_url,
    this.last_commit,
    this.sidebar,
    this.sub_url,
    this.title,
  });
  factory WikiPage.fromJson(Map<String, dynamic> json) {
    return WikiPage(
      commit_count: json['commit_count'] != null
          ? (json['commit_count'] as num).toInt()
          : null,
      content_base64: json['content_base64'] != null
          ? json['content_base64'] as String
          : null,
      footer: json['footer'] != null ? json['footer'] as String : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      last_commit: json['last_commit'] != null
          ? WikiCommit.fromJson(json['last_commit'] as Map<String, dynamic>)
          : null,
      sidebar: json['sidebar'] != null ? json['sidebar'] as String : null,
      sub_url: json['sub_url'] != null ? json['sub_url'] as String : null,
      title: json['title'] != null ? json['title'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (commit_count != null) map['commit_count'] = commit_count!;
    if (content_base64 != null) map['content_base64'] = content_base64!;
    if (footer != null) map['footer'] = footer!;
    if (html_url != null) map['html_url'] = html_url!;
    if (last_commit != null) map['last_commit'] = last_commit!.toJson();
    if (sidebar != null) map['sidebar'] = sidebar!;
    if (sub_url != null) map['sub_url'] = sub_url!;
    if (title != null) map['title'] = title!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WikiPage &&
          commit_count == other.commit_count &&
          content_base64 == other.content_base64 &&
          footer == other.footer &&
          html_url == other.html_url &&
          last_commit == other.last_commit &&
          sidebar == other.sidebar &&
          sub_url == other.sub_url &&
          title == other.title;
  @override
  int get hashCode => Object.hash(
    commit_count,
    content_base64,
    footer,
    html_url,
    last_commit,
    sidebar,
    sub_url,
    title,
  );
  @override
  String toString() =>
      'WikiPage(commit_count: $commit_count, content_base64: $content_base64, footer: $footer, html_url: $html_url, last_commit: $last_commit, sidebar: $sidebar, sub_url: $sub_url, title: $title)';
}
