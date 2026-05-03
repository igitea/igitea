part of 'generated_models.dart';

/// Identity for a person's identity like an author or committer
class Identity {
  final String? email;
  final String? name;
  const Identity({
    this.email,
    this.name,
  });
  factory Identity.fromJson(Map<String, dynamic> json) {
    return Identity(
      email: json['email'] != null ? json['email'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (email != null) map['email'] = email!;
    if (name != null) map['name'] = name!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Identity &&
          email == other.email &&
          name == other.name;
  @override
  int get hashCode => Object.hash(email, name);
  @override
  String toString() => 'Identity(email: $email, name: $name)';
}
