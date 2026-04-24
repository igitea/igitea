part of 'generated_models.dart';

/// RenameUserOption options when renaming a user
class RenameUserOption {
  final String? new_username;
  const RenameUserOption({this.new_username});
  factory RenameUserOption.fromJson(Map<String, dynamic> json) {
    return RenameUserOption(
      new_username: json['new_username'] != null
          ? json['new_username'] as String
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (new_username != null) map['new_username'] = new_username!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenameUserOption && new_username == other.new_username;
  @override
  int get hashCode => new_username.hashCode;
  @override
  String toString() => 'RenameUserOption(new_username: $new_username)';
}
