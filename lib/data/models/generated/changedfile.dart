part of 'generated_models.dart';

/// ChangedFile store information about files affected by the pull request
class ChangedFile {
  final int? additions;
  final int? changes;
  final String? contents_url;
  final int? deletions;
  final String? filename;
  final String? html_url;
  final String? previous_filename;
  final String? raw_url;
  final String? status;
  const ChangedFile({
    this.additions,
    this.changes,
    this.contents_url,
    this.deletions,
    this.filename,
    this.html_url,
    this.previous_filename,
    this.raw_url,
    this.status,
  });
  factory ChangedFile.fromJson(Map<String, dynamic> json) {
    return ChangedFile(
      additions: json['additions'] != null
          ? (json['additions'] as num).toInt()
          : null,
      changes: json['changes'] != null
          ? (json['changes'] as num).toInt()
          : null,
      contents_url: json['contents_url'] != null
          ? json['contents_url'] as String
          : null,
      deletions: json['deletions'] != null
          ? (json['deletions'] as num).toInt()
          : null,
      filename: json['filename'] != null ? json['filename'] as String : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      previous_filename: json['previous_filename'] != null
          ? json['previous_filename'] as String
          : null,
      raw_url: json['raw_url'] != null ? json['raw_url'] as String : null,
      status: json['status'] != null ? json['status'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (additions != null) map['additions'] = additions!;
    if (changes != null) map['changes'] = changes!;
    if (contents_url != null) map['contents_url'] = contents_url!;
    if (deletions != null) map['deletions'] = deletions!;
    if (filename != null) map['filename'] = filename!;
    if (html_url != null) map['html_url'] = html_url!;
    if (previous_filename != null)
      map['previous_filename'] = previous_filename!;
    if (raw_url != null) map['raw_url'] = raw_url!;
    if (status != null) map['status'] = status!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangedFile &&
          additions == other.additions &&
          changes == other.changes &&
          contents_url == other.contents_url &&
          deletions == other.deletions &&
          filename == other.filename &&
          html_url == other.html_url &&
          previous_filename == other.previous_filename &&
          raw_url == other.raw_url &&
          status == other.status;
  @override
  int get hashCode => Object.hash(
    additions,
    changes,
    contents_url,
    deletions,
    filename,
    html_url,
    previous_filename,
    raw_url,
    status,
  );
  @override
  String toString() =>
      'ChangedFile(additions: $additions, changes: $changes, contents_url: $contents_url, deletions: $deletions, filename: $filename, html_url: $html_url, previous_filename: $previous_filename, raw_url: $raw_url, status: $status)';
}
