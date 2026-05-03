part of 'generated_models.dart';

/// ActionArtifactsResponse returns ActionArtifacts
class ActionArtifactsResponse {
  final List<ActionArtifact>? artifacts;
  final int? total_count;
  const ActionArtifactsResponse({
    this.artifacts,
    this.total_count,
  });
  factory ActionArtifactsResponse.fromJson(Map<String, dynamic> json) {
    return ActionArtifactsResponse(
      artifacts: json['artifacts'] != null ? (json['artifacts'] as List<dynamic>).map((e) => ActionArtifact.fromJson(e as Map<String, dynamic>)).toList() : null,
      total_count: json['total_count'] != null ? (json['total_count'] as num).toInt() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (artifacts != null) map['artifacts'] = artifacts!.map((e) => e.toJson()).toList();
    if (total_count != null) map['total_count'] = total_count!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionArtifactsResponse &&
          artifacts == other.artifacts &&
          total_count == other.total_count;
  @override
  int get hashCode => Object.hash(artifacts, total_count);
  @override
  String toString() => 'ActionArtifactsResponse(artifacts: $artifacts, total_count: $total_count)';
}
