part of 'generated_models.dart';

/// FileResponse contains information about a repo's file
class FileResponse {
  final FileCommitResponse? commit;
  final ContentsResponse? content;
  final PayloadCommitVerification? verification;
  const FileResponse({this.commit, this.content, this.verification});
  factory FileResponse.fromJson(Map<String, dynamic> json) {
    return FileResponse(
      commit: json['commit'] != null
          ? FileCommitResponse.fromJson(json['commit'] as Map<String, dynamic>)
          : null,
      content: json['content'] != null
          ? ContentsResponse.fromJson(json['content'] as Map<String, dynamic>)
          : null,
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
    if (content != null) map['content'] = content!.toJson();
    if (verification != null) map['verification'] = verification!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileResponse &&
          commit == other.commit &&
          content == other.content &&
          verification == other.verification;
  @override
  int get hashCode => Object.hash(commit, content, verification);
  @override
  String toString() =>
      'FileResponse(commit: $commit, content: $content, verification: $verification)';
}
