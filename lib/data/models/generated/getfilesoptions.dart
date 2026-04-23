part of 'generated_models.dart';

/// GetFilesOptions options for retrieving metadate and content of multiple files
class GetFilesOptions {
  final List<String>? files;
  const GetFilesOptions({
    this.files,
  });
  factory GetFilesOptions.fromJson(Map<String, dynamic> json) {
    return GetFilesOptions(
      files: json['files'] != null ? (json['files'] as List<dynamic>).cast<String>() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (files != null) map['files'] = files!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetFilesOptions &&
          files == other.files;
  @override
  int get hashCode => files.hashCode;
  @override
  String toString() => 'GetFilesOptions(files: $files)';
}
