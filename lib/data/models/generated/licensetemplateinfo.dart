part of 'generated_models.dart';

/// LicensesInfo contains information about a License
class LicenseTemplateInfo {
  final String? body;
  final String? implementation;
  final String? key;
  final String? name;
  final String? url;
  const LicenseTemplateInfo({
    this.body,
    this.implementation,
    this.key,
    this.name,
    this.url,
  });
  factory LicenseTemplateInfo.fromJson(Map<String, dynamic> json) {
    return LicenseTemplateInfo(
      body: json['body'] != null ? json['body'] as String : null,
      implementation: json['implementation'] != null ? json['implementation'] as String : null,
      key: json['key'] != null ? json['key'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (body != null) map['body'] = body!;
    if (implementation != null) map['implementation'] = implementation!;
    if (key != null) map['key'] = key!;
    if (name != null) map['name'] = name!;
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LicenseTemplateInfo &&
          body == other.body &&
          implementation == other.implementation &&
          key == other.key &&
          name == other.name &&
          url == other.url;
  @override
  int get hashCode => Object.hash(body, implementation, key, name, url);
  @override
  String toString() => 'LicenseTemplateInfo(body: $body, implementation: $implementation, key: $key, name: $name, url: $url)';
}
