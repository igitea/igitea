part of 'generated_models.dart';

/// ActionRunnersResponse returns Runners
class ActionRunnersResponse {
  final List<ActionRunner>? runners;
  final int? total_count;
  const ActionRunnersResponse({this.runners, this.total_count});
  factory ActionRunnersResponse.fromJson(Map<String, dynamic> json) {
    return ActionRunnersResponse(
      runners: json['runners'] != null
          ? (json['runners'] as List<dynamic>)
                .map((e) => ActionRunner.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      total_count: json['total_count'] != null
          ? (json['total_count'] as num).toInt()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (runners != null)
      map['runners'] = runners!.map((e) => e.toJson()).toList();
    if (total_count != null) map['total_count'] = total_count!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionRunnersResponse &&
          runners == other.runners &&
          total_count == other.total_count;
  @override
  int get hashCode => Object.hash(runners, total_count);
  @override
  String toString() =>
      'ActionRunnersResponse(runners: $runners, total_count: $total_count)';
}
