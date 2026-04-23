part of 'generated_models.dart';

/// CommitUser contains information of a user in the context of a commit.
class CommitUser {
  final String? date;
  final String? email;
  final String? name;
  const CommitUser({
    this.date,
    this.email,
    this.name,
  });
  factory CommitUser.fromJson(Map<String, dynamic> json) {
    return CommitUser(
      date: json['date'] != null ? json['date'] as String : null,
      email: json['email'] != null ? json['email'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (date != null) map['date'] = date!;
    if (email != null) map['email'] = email!;
    if (name != null) map['name'] = name!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommitUser &&
          date == other.date &&
          email == other.email &&
          name == other.name;
  @override
  int get hashCode => Object.hash(date, email, name);
  @override
  String toString() => 'CommitUser(date: $date, email: $email, name: $name)';
}
