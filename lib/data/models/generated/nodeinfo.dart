part of 'generated_models.dart';

/// NodeInfo contains standardized way of exposing metadata about a server running one of the distributed social networks
class NodeInfo {
  final Map<String, dynamic>? metadata;
  final bool? openRegistrations;
  final List<String>? protocols;
  final NodeInfoServices? services;
  final NodeInfoSoftware? software;
  final NodeInfoUsage? usage;
  final String? version;
  const NodeInfo({
    this.metadata,
    this.openRegistrations,
    this.protocols,
    this.services,
    this.software,
    this.usage,
    this.version,
  });
  factory NodeInfo.fromJson(Map<String, dynamic> json) {
    return NodeInfo(
      metadata: json['metadata'] != null
          ? json['metadata'] as Map<String, dynamic>
          : null,
      openRegistrations: json['openRegistrations'] != null
          ? json['openRegistrations'] as bool
          : null,
      protocols: json['protocols'] != null
          ? (json['protocols'] as List<dynamic>).cast<String>()
          : null,
      services: json['services'] != null
          ? NodeInfoServices.fromJson(json['services'] as Map<String, dynamic>)
          : null,
      software: json['software'] != null
          ? NodeInfoSoftware.fromJson(json['software'] as Map<String, dynamic>)
          : null,
      usage: json['usage'] != null
          ? NodeInfoUsage.fromJson(json['usage'] as Map<String, dynamic>)
          : null,
      version: json['version'] != null ? json['version'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (metadata != null) map['metadata'] = metadata!;
    if (openRegistrations != null)
      map['openRegistrations'] = openRegistrations!;
    if (protocols != null) map['protocols'] = protocols!;
    if (services != null) map['services'] = services!.toJson();
    if (software != null) map['software'] = software!.toJson();
    if (usage != null) map['usage'] = usage!.toJson();
    if (version != null) map['version'] = version!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeInfo &&
          metadata == other.metadata &&
          openRegistrations == other.openRegistrations &&
          protocols == other.protocols &&
          services == other.services &&
          software == other.software &&
          usage == other.usage &&
          version == other.version;
  @override
  int get hashCode => Object.hash(
    metadata,
    openRegistrations,
    protocols,
    services,
    software,
    usage,
    version,
  );
  @override
  String toString() =>
      'NodeInfo(metadata: $metadata, openRegistrations: $openRegistrations, protocols: $protocols, services: $services, software: $software, usage: $usage, version: $version)';
}
