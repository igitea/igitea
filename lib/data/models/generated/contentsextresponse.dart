part of 'generated_models.dart';

class ContentsExtResponse {
  final List<ContentsResponse>? dir_contents;
  final ContentsResponse? file_contents;
  const ContentsExtResponse({
    this.dir_contents,
    this.file_contents,
  });
  factory ContentsExtResponse.fromJson(Map<String, dynamic> json) {
    return ContentsExtResponse(
      dir_contents: json['dir_contents'] != null ? (json['dir_contents'] as List<dynamic>).map((e) => ContentsResponse.fromJson(e as Map<String, dynamic>)).toList() : null,
      file_contents: json['file_contents'] != null ? ContentsResponse.fromJson(json['file_contents'] as Map<String, dynamic>) : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (dir_contents != null) map['dir_contents'] = dir_contents!.map((e) => e.toJson()).toList();
    if (file_contents != null) map['file_contents'] = file_contents!.toJson();
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentsExtResponse &&
          dir_contents == other.dir_contents &&
          file_contents == other.file_contents;
  @override
  int get hashCode => Object.hash(dir_contents, file_contents);
  @override
  String toString() => 'ContentsExtResponse(dir_contents: $dir_contents, file_contents: $file_contents)';
}
