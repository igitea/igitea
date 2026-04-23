part of 'generated_models.dart';

/// WikiPageMetaData wiki page meta information
class WikiPageMetaData {
  final String? html_url;
  final WikiCommit? last_commit;
  final String? sub_url;
  final String? title;
  const WikiPageMetaData({
    this.html_url,
    this.last_commit,
    this.sub_url,
    this.title,
  });
  factory WikiPageMetaData.fromJson(Map<String, dynamic> json) {
    return WikiPageMetaData(
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      last_commit: json['last_commit'] != null ? WikiCommit.fromJson(json['last_commit'] as Map<String, dynamic>) : null,
      sub_url: json['sub_url'] != null ? json['sub_url'] as String : null,
      title: json['title'] != null ? json['title'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (html_url != null) map['html_url'] = html_url!;
    if (last_commit != null) map['last_commit'] = last_commit!.toJson();
    if (sub_url != null) map['sub_url'] = sub_url!;
    if (title != null) map['title'] = title!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WikiPageMetaData &&
          html_url == other.html_url &&
          last_commit == other.last_commit &&
          sub_url == other.sub_url &&
          title == other.title;
  @override
  int get hashCode => Object.hash(html_url, last_commit, sub_url, title);
  @override
  String toString() => 'WikiPageMetaData(html_url: $html_url, last_commit: $last_commit, sub_url: $sub_url, title: $title)';
}
