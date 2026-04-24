part of 'generated_models.dart';

/// FileDeleteResponse contains information about a repo's file that was deleted
class FileDeleteResponse {
  final FileCommitResponse? commit;
  final dynamic content;
  final PayloadCommitVerification? verification;
  const FileDeleteResponse({this.commit, this.content, this.verification});
  factory FileDeleteResponse.fromJson(Map<String, dynamic> json) {
    return FileDeleteResponse(
      commit: json['commit'] != null
          ? FileCommitResponse.fromJson(json['commit'] as Map<String, dynamic>)
          : null,
      content: json['content'] != null ? json['content'] : null,
      verification: json['verification'] != null
          ? PayloadCommitVerification.fromJson(
              json['verification'] as Map<String, dynamic>,
            )
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (commit != null) map['commit'] = commit!.toJson();
    if (content != null) map['content'] = content!;
    if (verification != null) map['verification'] = verification!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileDeleteResponse &&
          commit == other.commit &&
          content == other.content &&
          verification == other.verification;
  @override
  int get hashCode => Object.hash(commit, content, verification);
  @override
  String toString() =>
      'FileDeleteResponse(commit: $commit, content: $content, verification: $verification)';
}
