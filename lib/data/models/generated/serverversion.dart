part of 'generated_models.dart';

/// ServerVersion wraps the version of the server
class ServerVersion {
  final String? version;
  const ServerVersion({
    this.version,
  });
  factory ServerVersion.fromJson(Map<String, dynamic> json) {
    return ServerVersion(
      version: json['version'] != null ? json['version'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (version != null) map['version'] = version!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerVersion &&
          version == other.version;
  @override
  int get hashCode => version.hashCode;
  @override
  String toString() => 'ServerVersion(version: $version)';
}
