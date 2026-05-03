part of 'generated_models.dart';

/// CreatePushMirrorOption represents need information to create a push mirror of a repository.
class CreatePushMirrorOption {
  final String? interval;
  final String? remote_address;
  final String? remote_password;
  final String? remote_username;
  final bool? sync_on_commit;
  const CreatePushMirrorOption({
    this.interval,
    this.remote_address,
    this.remote_password,
    this.remote_username,
    this.sync_on_commit,
  });
  factory CreatePushMirrorOption.fromJson(Map<String, dynamic> json) {
    return CreatePushMirrorOption(
      interval: json['interval'] != null ? json['interval'] as String : null,
      remote_address: json['remote_address'] != null ? json['remote_address'] as String : null,
      remote_password: json['remote_password'] != null ? json['remote_password'] as String : null,
      remote_username: json['remote_username'] != null ? json['remote_username'] as String : null,
      sync_on_commit: json['sync_on_commit'] != null ? json['sync_on_commit'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (interval != null) map['interval'] = interval!;
    if (remote_address != null) map['remote_address'] = remote_address!;
    if (remote_password != null) map['remote_password'] = remote_password!;
    if (remote_username != null) map['remote_username'] = remote_username!;
    if (sync_on_commit != null) map['sync_on_commit'] = sync_on_commit!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreatePushMirrorOption &&
          interval == other.interval &&
          remote_address == other.remote_address &&
          remote_password == other.remote_password &&
          remote_username == other.remote_username &&
          sync_on_commit == other.sync_on_commit;
  @override
  int get hashCode => Object.hash(interval, remote_address, remote_password, remote_username, sync_on_commit);
  @override
  String toString() => 'CreatePushMirrorOption(interval: $interval, remote_address: $remote_address, remote_password: $remote_password, remote_username: $remote_username, sync_on_commit: $sync_on_commit)';
}
