part of 'generated_models.dart';

/// NotificationThread expose Notification on API
class NotificationThread {
  final int? id;
  final bool? pinned;
  final Repository? repository;
  final NotificationSubject? subject;
  final bool? unread;
  final DateTime? updated_at;
  final String? url;
  const NotificationThread({
    this.id,
    this.pinned,
    this.repository,
    this.subject,
    this.unread,
    this.updated_at,
    this.url,
  });
  factory NotificationThread.fromJson(Map<String, dynamic> json) {
    return NotificationThread(
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      pinned: json['pinned'] != null ? json['pinned'] as bool : null,
      repository: json['repository'] != null
          ? Repository.fromJson(json['repository'] as Map<String, dynamic>)
          : null,
      subject: json['subject'] != null
          ? NotificationSubject.fromJson(
              json['subject'] as Map<String, dynamic>,
            )
          : null,
      unread: json['unread'] != null ? json['unread'] as bool : null,
      updated_at: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id!;
    if (pinned != null) map['pinned'] = pinned!;
    if (repository != null) map['repository'] = repository!.toJson();
    if (subject != null) map['subject'] = subject!.toJson();
    if (unread != null) map['unread'] = unread!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (url != null) map['url'] = url!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationThread &&
          id == other.id &&
          pinned == other.pinned &&
          repository == other.repository &&
          subject == other.subject &&
          unread == other.unread &&
          updated_at == other.updated_at &&
          url == other.url;
  @override
  int get hashCode =>
      Object.hash(id, pinned, repository, subject, unread, updated_at, url);
  @override
  String toString() =>
      'NotificationThread(id: $id, pinned: $pinned, repository: $repository, subject: $subject, unread: $unread, updated_at: $updated_at, url: $url)';
}
