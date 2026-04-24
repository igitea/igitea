part of 'generated_models.dart';

/// NotificationSubject contains the notification subject (Issue/Pull/Commit)
class NotificationSubject {
  final String? html_url;
  final String? latest_comment_html_url;
  final String? latest_comment_url;
  final StateType? state;
  final String? title;
  final NotifySubjectType? type;
  final String? url;
  const NotificationSubject({
    this.html_url,
    this.latest_comment_html_url,
    this.latest_comment_url,
    this.state,
    this.title,
    this.type,
    this.url,
  });
  factory NotificationSubject.fromJson(Map<String, dynamic> json) {
    return NotificationSubject(
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      latest_comment_html_url: json['latest_comment_html_url'] != null
          ? json['latest_comment_html_url'] as String
          : null,
      latest_comment_url: json['latest_comment_url'] != null
          ? json['latest_comment_url'] as String
          : null,
      state: json['state'] != null
          ? StateType.fromJson(json['state'])
          : null,
      title: json['title'] != null ? json['title'] as String : null,
      type: json['type'] != null
          ? NotifySubjectType.fromJson(json['type'] as Map<String, dynamic>)
          : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (html_url != null) map['html_url'] = html_url!;
    if (latest_comment_html_url != null)
      map['latest_comment_html_url'] = latest_comment_html_url!;
    if (latest_comment_url != null)
      map['latest_comment_url'] = latest_comment_url!;
    if (state != null) map['state'] = state!.toJson();
    if (title != null) map['title'] = title!;
    if (type != null) map['type'] = type!.toJson();
    if (url != null) map['url'] = url!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSubject &&
          html_url == other.html_url &&
          latest_comment_html_url == other.latest_comment_html_url &&
          latest_comment_url == other.latest_comment_url &&
          state == other.state &&
          title == other.title &&
          type == other.type &&
          url == other.url;
  @override
  int get hashCode => Object.hash(
    html_url,
    latest_comment_html_url,
    latest_comment_url,
    state,
    title,
    type,
    url,
  );
  @override
  String toString() =>
      'NotificationSubject(html_url: $html_url, latest_comment_html_url: $latest_comment_html_url, latest_comment_url: $latest_comment_url, state: $state, title: $title, type: $type, url: $url)';
}
