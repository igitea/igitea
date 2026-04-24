part of 'generated_models.dart';

/// Hook a hook is a web hook when one repository changed
class Hook {
  final bool? active;
  final String? authorization_header;
  final String? branch_filter;
  final Map<String, dynamic>? config;
  final DateTime? created_at;
  final List<String>? events;
  final int? id;
  final String? type;
  final DateTime? updated_at;
  const Hook({
    this.active,
    this.authorization_header,
    this.branch_filter,
    this.config,
    this.created_at,
    this.events,
    this.id,
    this.type,
    this.updated_at,
  });
  factory Hook.fromJson(Map<String, dynamic> json) {
    return Hook(
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
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      events: json['events'] != null
          ? (json['events'] as List<dynamic>).cast<String>()
          : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      type: json['type'] != null ? json['type'] as String : null,
      updated_at: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
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
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (events != null) map['events'] = events!;
    if (id != null) map['id'] = id!;
    if (type != null) map['type'] = type!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Hook &&
          active == other.active &&
          authorization_header == other.authorization_header &&
          branch_filter == other.branch_filter &&
          config == other.config &&
          created_at == other.created_at &&
          events == other.events &&
          id == other.id &&
          type == other.type &&
          updated_at == other.updated_at;
  @override
  int get hashCode => Object.hash(
    active,
    authorization_header,
    branch_filter,
    config,
    created_at,
    events,
    id,
    type,
    updated_at,
  );
  @override
  String toString() =>
      'Hook(active: $active, authorization_header: $authorization_header, branch_filter: $branch_filter, config: $config, created_at: $created_at, events: $events, id: $id, type: $type, updated_at: $updated_at)';
}
