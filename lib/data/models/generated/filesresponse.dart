part of 'generated_models.dart';

/// FilesResponse contains information about multiple files from a repo
class FilesResponse {
  final FileCommitResponse? commit;
  final List<ContentsResponse>? files;
  final PayloadCommitVerification? verification;
  const FilesResponse({
    this.commit,
    this.files,
    this.verification,
  });
  factory FilesResponse.fromJson(Map<String, dynamic> json) {
    return FilesResponse(
      commit: json['commit'] != null ? FileCommitResponse.fromJson(json['commit'] as Map<String, dynamic>) : null,
      files: json['files'] != null ? (json['files'] as List<dynamic>).map((e) => ContentsResponse.fromJson(e as Map<String, dynamic>)).toList() : null,
      verification: json['verification'] != null ? PayloadCommitVerification.fromJson(json['verification'] as Map<String, dynamic>) : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (commit != null) map['commit'] = commit!.toJson();
    if (files != null) map['files'] = files!.map((e) => e.toJson()).toList();
    if (verification != null) map['verification'] = verification!.toJson();
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilesResponse &&
          commit == other.commit &&
          files == other.files &&
          verification == other.verification;
  @override
  int get hashCode => Object.hash(commit, files, verification);
  @override
  String toString() => 'FilesResponse(commit: $commit, files: $files, verification: $verification)';
}
