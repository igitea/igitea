part of 'generated_models.dart';

/// PayloadUser represents the author or committer of a commit
class PayloadUser {
  final String? email;
  final String? name;
  final String? username;
  const PayloadUser({this.email, this.name, this.username});
  factory PayloadUser.fromJson(Map<String, dynamic> json) {
    return PayloadUser(
      email: json['email'] != null ? json['email'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      username: json['username'] != null ? json['username'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (email != null) map['email'] = email!;
    if (name != null) map['name'] = name!;
    if (username != null) map['username'] = username!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayloadUser &&
          email == other.email &&
          name == other.name &&
          username == other.username;
  @override
  int get hashCode => Object.hash(email, name, username);
  @override
  String toString() =>
      'PayloadUser(email: $email, name: $name, username: $username)';
}
