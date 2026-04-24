part of 'generated_models.dart';

/// Reaction contain one reaction
class Reaction {
  final String? content;
  final DateTime? created_at;
  final User? user;
  const Reaction({this.content, this.created_at, this.user});
  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      content: json['content'] != null ? json['content'] as String : null,
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (content != null) map['content'] = content!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (user != null) map['user'] = user!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reaction &&
          content == other.content &&
          created_at == other.created_at &&
          user == other.user;
  @override
  int get hashCode => Object.hash(content, created_at, user);
  @override
  String toString() =>
      'Reaction(content: $content, created_at: $created_at, user: $user)';
}
