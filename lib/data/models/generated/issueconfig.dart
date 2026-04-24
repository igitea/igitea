part of 'generated_models.dart';

class IssueConfig {
  final bool? blank_issues_enabled;
  final List<IssueConfigContactLink>? contact_links;
  const IssueConfig({this.blank_issues_enabled, this.contact_links});
  factory IssueConfig.fromJson(Map<String, dynamic> json) {
    return IssueConfig(
      blank_issues_enabled: json['blank_issues_enabled'] != null
          ? json['blank_issues_enabled'] as bool
          : null,
      contact_links: json['contact_links'] != null
          ? (json['contact_links'] as List<dynamic>)
                .map(
                  (e) => IssueConfigContactLink.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (blank_issues_enabled != null)
      map['blank_issues_enabled'] = blank_issues_enabled!;
    if (contact_links != null)
      map['contact_links'] = contact_links!.map((e) => e.toJson()).toList();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueConfig &&
          blank_issues_enabled == other.blank_issues_enabled &&
          contact_links == other.contact_links;
  @override
  int get hashCode => Object.hash(blank_issues_enabled, contact_links);
  @override
  String toString() =>
      'IssueConfig(blank_issues_enabled: $blank_issues_enabled, contact_links: $contact_links)';
}
