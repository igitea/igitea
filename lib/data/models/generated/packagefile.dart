part of 'generated_models.dart';

/// PackageFile represents a package file
class PackageFile {
  final int? id;
  final String? md5;
  final String? name;
  final String? sha1;
  final String? sha256;
  final String? sha512;
  final int? size;
  const PackageFile({
    this.id,
    this.md5,
    this.name,
    this.sha1,
    this.sha256,
    this.sha512,
    this.size,
  });
  factory PackageFile.fromJson(Map<String, dynamic> json) {
    return PackageFile(
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      md5: json['md5'] != null ? json['md5'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      sha1: json['sha1'] != null ? json['sha1'] as String : null,
      sha256: json['sha256'] != null ? json['sha256'] as String : null,
      sha512: json['sha512'] != null ? json['sha512'] as String : null,
      size: json['size'] != null ? (json['size'] as num).toInt() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id!;
    if (md5 != null) map['md5'] = md5!;
    if (name != null) map['name'] = name!;
    if (sha1 != null) map['sha1'] = sha1!;
    if (sha256 != null) map['sha256'] = sha256!;
    if (sha512 != null) map['sha512'] = sha512!;
    if (size != null) map['size'] = size!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackageFile &&
          id == other.id &&
          md5 == other.md5 &&
          name == other.name &&
          sha1 == other.sha1 &&
          sha256 == other.sha256 &&
          sha512 == other.sha512 &&
          size == other.size;
  @override
  int get hashCode => Object.hash(id, md5, name, sha1, sha256, sha512, size);
  @override
  String toString() =>
      'PackageFile(id: $id, md5: $md5, name: $name, sha1: $sha1, sha256: $sha256, sha512: $sha512, size: $size)';
}
