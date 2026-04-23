part of 'generated_models.dart';

/// Email an email address belonging to a user
class Email {
  final String? email;
  final bool? primary;
  final int? user_id;
  final String? username;
  final bool? verified;
  const Email({
    this.email,
    this.primary,
    this.user_id,
    this.username,
    this.verified,
  });
  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      email: json['email'] != null ? json['email'] as String : null,
      primary: json['primary'] != null ? json['primary'] as bool : null,
      user_id: json['user_id'] != null ? (json['user_id'] as num).toInt() : null,
      username: json['username'] != null ? json['username'] as String : null,
      verified: json['verified'] != null ? json['verified'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (email != null) map['email'] = email!;
    if (primary != null) map['primary'] = primary!;
    if (user_id != null) map['user_id'] = user_id!;
    if (username != null) map['username'] = username!;
    if (verified != null) map['verified'] = verified!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Email &&
          email == other.email &&
          primary == other.primary &&
          user_id == other.user_id &&
          username == other.username &&
          verified == other.verified;
  @override
  int get hashCode => Object.hash(email, primary, user_id, username, verified);
  @override
  String toString() => 'Email(email: $email, primary: $primary, user_id: $user_id, username: $username, verified: $verified)';
}
