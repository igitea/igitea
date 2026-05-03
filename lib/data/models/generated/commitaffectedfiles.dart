part of 'generated_models.dart';

/// CommitAffectedFiles store information about files affected by the commit
class CommitAffectedFiles {
  final String? filename;
  final String? status;
  const CommitAffectedFiles({
    this.filename,
    this.status,
  });
  factory CommitAffectedFiles.fromJson(Map<String, dynamic> json) {
    return CommitAffectedFiles(
      filename: json['filename'] != null ? json['filename'] as String : null,
      status: json['status'] != null ? json['status'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (filename != null) map['filename'] = filename!;
    if (status != null) map['status'] = status!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommitAffectedFiles &&
          filename == other.filename &&
          status == other.status;
  @override
  int get hashCode => Object.hash(filename, status);
  @override
  String toString() => 'CommitAffectedFiles(filename: $filename, status: $status)';
}
