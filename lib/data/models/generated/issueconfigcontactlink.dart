part of 'generated_models.dart';

class IssueConfigContactLink {
  final String? about;
  final String? name;
  final String? url;
  const IssueConfigContactLink({
    this.about,
    this.name,
    this.url,
  });
  factory IssueConfigContactLink.fromJson(Map<String, dynamic> json) {
    return IssueConfigContactLink(
      about: json['about'] != null ? json['about'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (about != null) map['about'] = about!;
    if (name != null) map['name'] = name!;
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueConfigContactLink &&
          about == other.about &&
          name == other.name &&
          url == other.url;
  @override
  int get hashCode => Object.hash(about, name, url);
  @override
  String toString() => 'IssueConfigContactLink(about: $about, name: $name, url: $url)';
}
