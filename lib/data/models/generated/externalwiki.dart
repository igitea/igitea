part of 'generated_models.dart';

/// ExternalWiki represents setting for external wiki
class ExternalWiki {
  final String? external_wiki_url;
  const ExternalWiki({
    this.external_wiki_url,
  });
  factory ExternalWiki.fromJson(Map<String, dynamic> json) {
    return ExternalWiki(
      external_wiki_url: json['external_wiki_url'] != null ? json['external_wiki_url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (external_wiki_url != null) map['external_wiki_url'] = external_wiki_url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExternalWiki &&
          external_wiki_url == other.external_wiki_url;
  @override
  int get hashCode => external_wiki_url.hashCode;
  @override
  String toString() => 'ExternalWiki(external_wiki_url: $external_wiki_url)';
}
