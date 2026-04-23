part of 'generated_models.dart';

/// Attachment a generic attachment
class Attachment {
  final String? browser_download_url;
  final DateTime? created_at;
  final int? download_count;
  final int? id;
  final String? name;
  final int? size;
  final String? uuid;
  const Attachment({
    this.browser_download_url,
    this.created_at,
    this.download_count,
    this.id,
    this.name,
    this.size,
    this.uuid,
  });
  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      browser_download_url: json['browser_download_url'] != null ? json['browser_download_url'] as String : null,
      created_at: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      download_count: json['download_count'] != null ? (json['download_count'] as num).toInt() : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      name: json['name'] != null ? json['name'] as String : null,
      size: json['size'] != null ? (json['size'] as num).toInt() : null,
      uuid: json['uuid'] != null ? json['uuid'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (browser_download_url != null) map['browser_download_url'] = browser_download_url!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (download_count != null) map['download_count'] = download_count!;
    if (id != null) map['id'] = id!;
    if (name != null) map['name'] = name!;
    if (size != null) map['size'] = size!;
    if (uuid != null) map['uuid'] = uuid!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attachment &&
          browser_download_url == other.browser_download_url &&
          created_at == other.created_at &&
          download_count == other.download_count &&
          id == other.id &&
          name == other.name &&
          size == other.size &&
          uuid == other.uuid;
  @override
  int get hashCode => Object.hash(browser_download_url, created_at, download_count, id, name, size, uuid);
  @override
  String toString() => 'Attachment(browser_download_url: $browser_download_url, created_at: $created_at, download_count: $download_count, id: $id, name: $name, size: $size, uuid: $uuid)';
}
