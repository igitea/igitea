part of 'generated_models.dart';

/// LicensesListEntry is used for the API
class LicensesTemplateListEntry {
  final String? key;
  final String? name;
  final String? url;
  const LicensesTemplateListEntry({this.key, this.name, this.url});
  factory LicensesTemplateListEntry.fromJson(Map<String, dynamic> json) {
    return LicensesTemplateListEntry(
      key: json['key'] != null ? json['key'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (key != null) map['key'] = key!;
    if (name != null) map['name'] = name!;
    if (url != null) map['url'] = url!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LicensesTemplateListEntry &&
          key == other.key &&
          name == other.name &&
          url == other.url;
  @override
  int get hashCode => Object.hash(key, name, url);
  @override
  String toString() =>
      'LicensesTemplateListEntry(key: $key, name: $name, url: $url)';
}
