part of 'generated_models.dart';

/// WatchInfo represents an API watch status of one repository
class WatchInfo {
  final DateTime? created_at;
  final bool? ignored;
  final dynamic reason;
  final String? repository_url;
  final bool? subscribed;
  final String? url;
  const WatchInfo({
    this.created_at,
    this.ignored,
    this.reason,
    this.repository_url,
    this.subscribed,
    this.url,
  });
  factory WatchInfo.fromJson(Map<String, dynamic> json) {
    return WatchInfo(
      created_at: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      ignored: json['ignored'] != null ? json['ignored'] as bool : null,
      reason: json['reason'] != null ? json['reason'] : null,
      repository_url: json['repository_url'] != null ? json['repository_url'] as String : null,
      subscribed: json['subscribed'] != null ? json['subscribed'] as bool : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (ignored != null) map['ignored'] = ignored!;
    if (reason != null) map['reason'] = reason!;
    if (repository_url != null) map['repository_url'] = repository_url!;
    if (subscribed != null) map['subscribed'] = subscribed!;
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchInfo &&
          created_at == other.created_at &&
          ignored == other.ignored &&
          reason == other.reason &&
          repository_url == other.repository_url &&
          subscribed == other.subscribed &&
          url == other.url;
  @override
  int get hashCode => Object.hash(created_at, ignored, reason, repository_url, subscribed, url);
  @override
  String toString() => 'WatchInfo(created_at: $created_at, ignored: $ignored, reason: $reason, repository_url: $repository_url, subscribed: $subscribed, url: $url)';
}
