part of 'generated_models.dart';

/// UserBadgeOption options for link between users and badges
class UserBadgeOption {
  final List<String>? badge_slugs;
  const UserBadgeOption({this.badge_slugs});
  factory UserBadgeOption.fromJson(Map<String, dynamic> json) {
    return UserBadgeOption(
      badge_slugs: json['badge_slugs'] != null
          ? (json['badge_slugs'] as List<dynamic>).cast<String>()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (badge_slugs != null) map['badge_slugs'] = badge_slugs!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBadgeOption && badge_slugs == other.badge_slugs;
  @override
  int get hashCode => badge_slugs.hashCode;
  @override
  String toString() => 'UserBadgeOption(badge_slugs: $badge_slugs)';
}
