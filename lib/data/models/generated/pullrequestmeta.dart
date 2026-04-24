part of 'generated_models.dart';

/// PullRequestMeta PR info if an issue is a PR
class PullRequestMeta {
  final bool? draft;
  final String? html_url;
  final bool? merged;
  final DateTime? merged_at;
  const PullRequestMeta({
    this.draft,
    this.html_url,
    this.merged,
    this.merged_at,
  });
  factory PullRequestMeta.fromJson(Map<String, dynamic> json) {
    return PullRequestMeta(
      draft: json['draft'] != null ? json['draft'] as bool : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      merged: json['merged'] != null ? json['merged'] as bool : null,
      merged_at: json['merged_at'] != null
          ? DateTime.parse(json['merged_at'] as String)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (draft != null) map['draft'] = draft!;
    if (html_url != null) map['html_url'] = html_url!;
    if (merged != null) map['merged'] = merged!;
    if (merged_at != null) map['merged_at'] = merged_at!.toIso8601String();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PullRequestMeta &&
          draft == other.draft &&
          html_url == other.html_url &&
          merged == other.merged &&
          merged_at == other.merged_at;
  @override
  int get hashCode => Object.hash(draft, html_url, merged, merged_at);
  @override
  String toString() =>
      'PullRequestMeta(draft: $draft, html_url: $html_url, merged: $merged, merged_at: $merged_at)';
}
