part of 'generated_models.dart';

/// Permission represents a set of permissions
class Permission {
  final bool? admin;
  final bool? pull;
  final bool? push;
  const Permission({this.admin, this.pull, this.push});
  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      admin: json['admin'] != null ? json['admin'] as bool : null,
      pull: json['pull'] != null ? json['pull'] as bool : null,
      push: json['push'] != null ? json['push'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (admin != null) map['admin'] = admin!;
    if (pull != null) map['pull'] = pull!;
    if (push != null) map['push'] = push!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Permission &&
          admin == other.admin &&
          pull == other.pull &&
          push == other.push;
  @override
  int get hashCode => Object.hash(admin, pull, push);
  @override
  String toString() => 'Permission(admin: $admin, pull: $pull, push: $push)';
}
