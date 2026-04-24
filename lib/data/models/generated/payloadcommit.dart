part of 'generated_models.dart';

/// PayloadCommit represents a commit
class PayloadCommit {
  final List<String>? added;
  final PayloadUser? author;
  final PayloadUser? committer;
  final String? id;
  final String? message;
  final List<String>? modified;
  final List<String>? removed;
  final DateTime? timestamp;
  final String? url;
  final PayloadCommitVerification? verification;
  const PayloadCommit({
    this.added,
    this.author,
    this.committer,
    this.id,
    this.message,
    this.modified,
    this.removed,
    this.timestamp,
    this.url,
    this.verification,
  });
  factory PayloadCommit.fromJson(Map<String, dynamic> json) {
    return PayloadCommit(
      added: json['added'] != null
          ? (json['added'] as List<dynamic>).cast<String>()
          : null,
      author: json['author'] != null
          ? PayloadUser.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      committer: json['committer'] != null
          ? PayloadUser.fromJson(json['committer'] as Map<String, dynamic>)
          : null,
      id: json['id'] != null ? json['id'] as String : null,
      message: json['message'] != null ? json['message'] as String : null,
      modified: json['modified'] != null
          ? (json['modified'] as List<dynamic>).cast<String>()
          : null,
      removed: json['removed'] != null
          ? (json['removed'] as List<dynamic>).cast<String>()
          : null,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      url: json['url'] != null ? json['url'] as String : null,
      verification: json['verification'] != null
          ? PayloadCommitVerification.fromJson(
              json['verification'] as Map<String, dynamic>,
            )
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (added != null) map['added'] = added!;
    if (author != null) map['author'] = author!.toJson();
    if (committer != null) map['committer'] = committer!.toJson();
    if (id != null) map['id'] = id!;
    if (message != null) map['message'] = message!;
    if (modified != null) map['modified'] = modified!;
    if (removed != null) map['removed'] = removed!;
    if (timestamp != null) map['timestamp'] = timestamp!.toIso8601String();
    if (url != null) map['url'] = url!;
    if (verification != null) map['verification'] = verification!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayloadCommit &&
          added == other.added &&
          author == other.author &&
          committer == other.committer &&
          id == other.id &&
          message == other.message &&
          modified == other.modified &&
          removed == other.removed &&
          timestamp == other.timestamp &&
          url == other.url &&
          verification == other.verification;
  @override
  int get hashCode => Object.hash(
    added,
    author,
    committer,
    id,
    message,
    modified,
    removed,
    timestamp,
    url,
    verification,
  );
  @override
  String toString() =>
      'PayloadCommit(added: $added, author: $author, committer: $committer, id: $id, message: $message, modified: $modified, removed: $removed, timestamp: $timestamp, url: $url, verification: $verification)';
}
