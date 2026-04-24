part of 'generated_models.dart';

/// UserHeatmapData represents the data needed to create a heatmap
class UserHeatmapData {
  final int? contributions;
  final TimeStamp? timestamp;
  const UserHeatmapData({this.contributions, this.timestamp});
  factory UserHeatmapData.fromJson(Map<String, dynamic> json) {
    return UserHeatmapData(
      contributions: json['contributions'] != null
          ? (json['contributions'] as num).toInt()
          : null,
      timestamp: json['timestamp'] != null
          ? TimeStamp.fromJson(json['timestamp'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (contributions != null) map['contributions'] = contributions!;
    if (timestamp != null) map['timestamp'] = timestamp!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserHeatmapData &&
          contributions == other.contributions &&
          timestamp == other.timestamp;
  @override
  int get hashCode => Object.hash(contributions, timestamp);
  @override
  String toString() =>
      'UserHeatmapData(contributions: $contributions, timestamp: $timestamp)';
}
