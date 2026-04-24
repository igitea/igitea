part of 'generated_models.dart';

/// NodeInfoUsageUsers contains statistics about the users of this server
class NodeInfoUsageUsers {
  final int? activeHalfyear;
  final int? activeMonth;
  final int? total;
  const NodeInfoUsageUsers({this.activeHalfyear, this.activeMonth, this.total});
  factory NodeInfoUsageUsers.fromJson(Map<String, dynamic> json) {
    return NodeInfoUsageUsers(
      activeHalfyear: json['activeHalfyear'] != null
          ? (json['activeHalfyear'] as num).toInt()
          : null,
      activeMonth: json['activeMonth'] != null
          ? (json['activeMonth'] as num).toInt()
          : null,
      total: json['total'] != null ? (json['total'] as num).toInt() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (activeHalfyear != null) map['activeHalfyear'] = activeHalfyear!;
    if (activeMonth != null) map['activeMonth'] = activeMonth!;
    if (total != null) map['total'] = total!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeInfoUsageUsers &&
          activeHalfyear == other.activeHalfyear &&
          activeMonth == other.activeMonth &&
          total == other.total;
  @override
  int get hashCode => Object.hash(activeHalfyear, activeMonth, total);
  @override
  String toString() =>
      'NodeInfoUsageUsers(activeHalfyear: $activeHalfyear, activeMonth: $activeMonth, total: $total)';
}
