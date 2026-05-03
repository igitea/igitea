part of 'generated_models.dart';

/// NodeInfoServices contains the third party sites this server can connect to via their application API
class NodeInfoServices {
  final List<String>? inbound;
  final List<String>? outbound;
  const NodeInfoServices({
    this.inbound,
    this.outbound,
  });
  factory NodeInfoServices.fromJson(Map<String, dynamic> json) {
    return NodeInfoServices(
      inbound: json['inbound'] != null ? (json['inbound'] as List<dynamic>).cast<String>() : null,
      outbound: json['outbound'] != null ? (json['outbound'] as List<dynamic>).cast<String>() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (inbound != null) map['inbound'] = inbound!;
    if (outbound != null) map['outbound'] = outbound!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeInfoServices &&
          inbound == other.inbound &&
          outbound == other.outbound;
  @override
  int get hashCode => Object.hash(inbound, outbound);
  @override
  String toString() => 'NodeInfoServices(inbound: $inbound, outbound: $outbound)';
}
