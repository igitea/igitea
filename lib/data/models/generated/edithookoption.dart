part of 'generated_models.dart';

/// EditHookOption options when modify one hook
class EditHookOption {
  final bool? active;
  final String? authorization_header;
  final String? branch_filter;
  final Map<String, dynamic>? config;
  final List<String>? events;
  const EditHookOption({
    this.active,
    this.authorization_header,
    this.branch_filter,
    this.config,
    this.events,
  });
  factory EditHookOption.fromJson(Map<String, dynamic> json) {
    return EditHookOption(
      active: json['active'] != null ? json['active'] as bool : null,
      authorization_header: json['authorization_header'] != null
          ? json['authorization_header'] as String
          : null,
      branch_filter: json['branch_filter'] != null
          ? json['branch_filter'] as String
          : null,
      config: json['config'] != null
          ? json['config'] as Map<String, dynamic>
          : null,
      events: json['events'] != null
          ? (json['events'] as List<dynamic>).cast<String>()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (active != null) map['active'] = active!;
    if (authorization_header != null)
      map['authorization_header'] = authorization_header!;
    if (branch_filter != null) map['branch_filter'] = branch_filter!;
    if (config != null) map['config'] = config!;
    if (events != null) map['events'] = events!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditHookOption &&
          active == other.active &&
          authorization_header == other.authorization_header &&
          branch_filter == other.branch_filter &&
          config == other.config &&
          events == other.events;
  @override
  int get hashCode =>
      Object.hash(active, authorization_header, branch_filter, config, events);
  @override
  String toString() =>
      'EditHookOption(active: $active, authorization_header: $authorization_header, branch_filter: $branch_filter, config: $config, events: $events)';
}
