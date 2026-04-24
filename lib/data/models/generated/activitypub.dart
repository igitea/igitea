part of 'generated_models.dart';

/// ActivityPub type
class ActivityPub {
  final String? at_context;
  const ActivityPub({this.at_context});
  factory ActivityPub.fromJson(Map<String, dynamic> json) {
    return ActivityPub(
      at_context: json['@context'] != null ? json['@context'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (at_context != null) map['@context'] = at_context!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityPub && at_context == other.at_context;
  @override
  int get hashCode => at_context.hashCode;
  @override
  String toString() => 'ActivityPub(at_context: $at_context)';
}
