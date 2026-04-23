part of 'generated_models.dart';

/// AddTimeOption options for adding time to an issue
class AddTimeOption {
  final DateTime? created;
  final int? time;
  final String? user_name;
  const AddTimeOption({
    this.created,
    this.time,
    this.user_name,
  });
  factory AddTimeOption.fromJson(Map<String, dynamic> json) {
    return AddTimeOption(
      created: json['created'] != null ? DateTime.parse(json['created'] as String) : null,
      time: json['time'] != null ? (json['time'] as num).toInt() : null,
      user_name: json['user_name'] != null ? json['user_name'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created != null) map['created'] = created!.toIso8601String();
    if (time != null) map['time'] = time!;
    if (user_name != null) map['user_name'] = user_name!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddTimeOption &&
          created == other.created &&
          time == other.time &&
          user_name == other.user_name;
  @override
  int get hashCode => Object.hash(created, time, user_name);
  @override
  String toString() => 'AddTimeOption(created: $created, time: $time, user_name: $user_name)';
}
