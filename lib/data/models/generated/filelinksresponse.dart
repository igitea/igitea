part of 'generated_models.dart';

/// FileLinksResponse contains the links for a repo's file
class FileLinksResponse {
  final String? git;
  final String? html;
  final String? self;
  const FileLinksResponse({this.git, this.html, this.self});
  factory FileLinksResponse.fromJson(Map<String, dynamic> json) {
    return FileLinksResponse(
      git: json['git'] != null ? json['git'] as String : null,
      html: json['html'] != null ? json['html'] as String : null,
      self: json['self'] != null ? json['self'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (git != null) map['git'] = git!;
    if (html != null) map['html'] = html!;
    if (self != null) map['self'] = self!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileLinksResponse &&
          git == other.git &&
          html == other.html &&
          self == other.self;
  @override
  int get hashCode => Object.hash(git, html, self);
  @override
  String toString() => 'FileLinksResponse(git: $git, html: $html, self: $self)';
}
