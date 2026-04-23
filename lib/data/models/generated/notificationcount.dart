part of 'generated_models.dart';

/// NotificationCount number of unread notifications
class NotificationCount {
  final int? new_;
  const NotificationCount({
    this.new_,
  });
  factory NotificationCount.fromJson(Map<String, dynamic> json) {
    return NotificationCount(
      new_: json['new'] != null ? (json['new'] as num).toInt() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (new_ != null) map['new'] = new_!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationCount &&
          new_ == other.new_;
  @override
  int get hashCode => new_.hashCode;
  @override
  String toString() => 'NotificationCount(new_: $new_)';
}
