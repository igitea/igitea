part of 'generated_models.dart';

/// AnnotatedTag represents an annotated tag
class AnnotatedTag {
  final String? message;
  final AnnotatedTagObject? object;
  final String? sha;
  final String? tag;
  final CommitUser? tagger;
  final String? url;
  final PayloadCommitVerification? verification;
  const AnnotatedTag({
    this.message,
    this.object,
    this.sha,
    this.tag,
    this.tagger,
    this.url,
    this.verification,
  });
  factory AnnotatedTag.fromJson(Map<String, dynamic> json) {
    return AnnotatedTag(
      message: json['message'] != null ? json['message'] as String : null,
      object: json['object'] != null ? AnnotatedTagObject.fromJson(json['object'] as Map<String, dynamic>) : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
      tag: json['tag'] != null ? json['tag'] as String : null,
      tagger: json['tagger'] != null ? CommitUser.fromJson(json['tagger'] as Map<String, dynamic>) : null,
      url: json['url'] != null ? json['url'] as String : null,
      verification: json['verification'] != null ? PayloadCommitVerification.fromJson(json['verification'] as Map<String, dynamic>) : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (message != null) map['message'] = message!;
    if (object != null) map['object'] = object!.toJson();
    if (sha != null) map['sha'] = sha!;
    if (tag != null) map['tag'] = tag!;
    if (tagger != null) map['tagger'] = tagger!.toJson();
    if (url != null) map['url'] = url!;
    if (verification != null) map['verification'] = verification!.toJson();
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnotatedTag &&
          message == other.message &&
          object == other.object &&
          sha == other.sha &&
          tag == other.tag &&
          tagger == other.tagger &&
          url == other.url &&
          verification == other.verification;
  @override
  int get hashCode => Object.hash(message, object, sha, tag, tagger, url, verification);
  @override
  String toString() => 'AnnotatedTag(message: $message, object: $object, sha: $sha, tag: $tag, tagger: $tagger, url: $url, verification: $verification)';
}
