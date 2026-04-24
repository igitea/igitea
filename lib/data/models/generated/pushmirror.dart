part of 'generated_models.dart';

/// PushMirror represents information of a push mirror
class PushMirror {
  final DateTime? created;
  final String? interval;
  final String? last_error;
  final DateTime? last_update;
  final String? remote_address;
  final String? remote_name;
  final String? repo_name;
  final bool? sync_on_commit;
  const PushMirror({
    this.created,
    this.interval,
    this.last_error,
    this.last_update,
    this.remote_address,
    this.remote_name,
    this.repo_name,
    this.sync_on_commit,
  });
  factory PushMirror.fromJson(Map<String, dynamic> json) {
    return PushMirror(
      created: json['created'] != null
          ? DateTime.parse(json['created'] as String)
          : null,
      interval: json['interval'] != null ? json['interval'] as String : null,
      last_error: json['last_error'] != null
          ? json['last_error'] as String
          : null,
      last_update: json['last_update'] != null
          ? DateTime.parse(json['last_update'] as String)
          : null,
      remote_address: json['remote_address'] != null
          ? json['remote_address'] as String
          : null,
      remote_name: json['remote_name'] != null
          ? json['remote_name'] as String
          : null,
      repo_name: json['repo_name'] != null ? json['repo_name'] as String : null,
      sync_on_commit: json['sync_on_commit'] != null
          ? json['sync_on_commit'] as bool
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (created != null) map['created'] = created!.toIso8601String();
    if (interval != null) map['interval'] = interval!;
    if (last_error != null) map['last_error'] = last_error!;
    if (last_update != null)
      map['last_update'] = last_update!.toIso8601String();
    if (remote_address != null) map['remote_address'] = remote_address!;
    if (remote_name != null) map['remote_name'] = remote_name!;
    if (repo_name != null) map['repo_name'] = repo_name!;
    if (sync_on_commit != null) map['sync_on_commit'] = sync_on_commit!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PushMirror &&
          created == other.created &&
          interval == other.interval &&
          last_error == other.last_error &&
          last_update == other.last_update &&
          remote_address == other.remote_address &&
          remote_name == other.remote_name &&
          repo_name == other.repo_name &&
          sync_on_commit == other.sync_on_commit;
  @override
  int get hashCode => Object.hash(
    created,
    interval,
    last_error,
    last_update,
    remote_address,
    remote_name,
    repo_name,
    sync_on_commit,
  );
  @override
  String toString() =>
      'PushMirror(created: $created, interval: $interval, last_error: $last_error, last_update: $last_update, remote_address: $remote_address, remote_name: $remote_name, repo_name: $repo_name, sync_on_commit: $sync_on_commit)';
}
