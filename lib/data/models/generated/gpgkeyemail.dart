part of 'generated_models.dart';

/// GPGKeyEmail an email attached to a GPGKey
class GPGKeyEmail {
  final String? email;
  final bool? verified;
  const GPGKeyEmail({
    this.email,
    this.verified,
  });
  factory GPGKeyEmail.fromJson(Map<String, dynamic> json) {
    return GPGKeyEmail(
      email: json['email'] != null ? json['email'] as String : null,
      verified: json['verified'] != null ? json['verified'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (email != null) map['email'] = email!;
    if (verified != null) map['verified'] = verified!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GPGKeyEmail &&
          email == other.email &&
          verified == other.verified;
  @override
  int get hashCode => Object.hash(email, verified);
  @override
  String toString() => 'GPGKeyEmail(email: $email, verified: $verified)';
}
