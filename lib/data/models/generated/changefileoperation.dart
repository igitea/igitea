part of 'generated_models.dart';

/// ChangeFileOperation for creating, updating or deleting a file
class ChangeFileOperation {
  final String? content;
  final String? from_path;
  final String? operation;
  final String? path;
  final String? sha;
  const ChangeFileOperation({
    this.content,
    this.from_path,
    this.operation,
    this.path,
    this.sha,
  });
  factory ChangeFileOperation.fromJson(Map<String, dynamic> json) {
    return ChangeFileOperation(
      content: json['content'] != null ? json['content'] as String : null,
      from_path: json['from_path'] != null ? json['from_path'] as String : null,
      operation: json['operation'] != null ? json['operation'] as String : null,
      path: json['path'] != null ? json['path'] as String : null,
      sha: json['sha'] != null ? json['sha'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (content != null) map['content'] = content!;
    if (from_path != null) map['from_path'] = from_path!;
    if (operation != null) map['operation'] = operation!;
    if (path != null) map['path'] = path!;
    if (sha != null) map['sha'] = sha!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangeFileOperation &&
          content == other.content &&
          from_path == other.from_path &&
          operation == other.operation &&
          path == other.path &&
          sha == other.sha;
  @override
  int get hashCode => Object.hash(content, from_path, operation, path, sha);
  @override
  String toString() => 'ChangeFileOperation(content: $content, from_path: $from_path, operation: $operation, path: $path, sha: $sha)';
}
