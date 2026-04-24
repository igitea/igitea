part of 'generated_models.dart';

class MergeUpstreamResponse {
  final String? merge_type;
  const MergeUpstreamResponse({this.merge_type});
  factory MergeUpstreamResponse.fromJson(Map<String, dynamic> json) {
    return MergeUpstreamResponse(
      merge_type: json['merge_type'] != null
          ? json['merge_type'] as String
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (merge_type != null) map['merge_type'] = merge_type!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MergeUpstreamResponse && merge_type == other.merge_type;
  @override
  int get hashCode => merge_type.hashCode;
  @override
  String toString() => 'MergeUpstreamResponse(merge_type: $merge_type)';
}
