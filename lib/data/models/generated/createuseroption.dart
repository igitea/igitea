part of 'generated_models.dart';

/// CreateUserOption create user options
class CreateUserOption {
  final DateTime? created_at;
  final String? email;
  final String? full_name;
  final String? login_name;
  final bool? must_change_password;
  final String? password;
  final bool? restricted;
  final bool? send_notify;
  final int? source_id;
  final String? username;
  final String? visibility;
  const CreateUserOption({
    this.created_at,
    this.email,
    this.full_name,
    this.login_name,
    this.must_change_password,
    this.password,
    this.restricted,
    this.send_notify,
    this.source_id,
    this.username,
    this.visibility,
  });
  factory CreateUserOption.fromJson(Map<String, dynamic> json) {
    return CreateUserOption(
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      email: json['email'] != null ? json['email'] as String : null,
      full_name: json['full_name'] != null ? json['full_name'] as String : null,
      login_name: json['login_name'] != null
          ? json['login_name'] as String
          : null,
      must_change_password: json['must_change_password'] != null
          ? json['must_change_password'] as bool
          : null,
      password: json['password'] != null ? json['password'] as String : null,
      restricted: json['restricted'] != null
          ? json['restricted'] as bool
          : null,
      send_notify: json['send_notify'] != null
          ? json['send_notify'] as bool
          : null,
      source_id: json['source_id'] != null
          ? (json['source_id'] as num).toInt()
          : null,
      username: json['username'] != null ? json['username'] as String : null,
      visibility: json['visibility'] != null
          ? json['visibility'] as String
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (email != null) map['email'] = email!;
    if (full_name != null) map['full_name'] = full_name!;
    if (login_name != null) map['login_name'] = login_name!;
    if (must_change_password != null)
      map['must_change_password'] = must_change_password!;
    if (password != null) map['password'] = password!;
    if (restricted != null) map['restricted'] = restricted!;
    if (send_notify != null) map['send_notify'] = send_notify!;
    if (source_id != null) map['source_id'] = source_id!;
    if (username != null) map['username'] = username!;
    if (visibility != null) map['visibility'] = visibility!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateUserOption &&
          created_at == other.created_at &&
          email == other.email &&
          full_name == other.full_name &&
          login_name == other.login_name &&
          must_change_password == other.must_change_password &&
          password == other.password &&
          restricted == other.restricted &&
          send_notify == other.send_notify &&
          source_id == other.source_id &&
          username == other.username &&
          visibility == other.visibility;
  @override
  int get hashCode => Object.hash(
    created_at,
    email,
    full_name,
    login_name,
    must_change_password,
    password,
    restricted,
    send_notify,
    source_id,
    username,
    visibility,
  );
  @override
  String toString() =>
      'CreateUserOption(created_at: $created_at, email: $email, full_name: $full_name, login_name: $login_name, must_change_password: $must_change_password, password: $password, restricted: $restricted, send_notify: $send_notify, source_id: $source_id, username: $username, visibility: $visibility)';
}
