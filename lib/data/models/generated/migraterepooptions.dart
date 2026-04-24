part of 'generated_models.dart';

/// MigrateRepoOptions options for migrating repository's this is used to interact with api v1
class MigrateRepoOptions {
  final String? auth_password;
  final String? auth_token;
  final String? auth_username;
  final String? aws_access_key_id;
  final String? aws_secret_access_key;
  final String? clone_addr;
  final String? description;
  final bool? issues;
  final bool? labels;
  final bool? lfs;
  final String? lfs_endpoint;
  final bool? milestones;
  final bool? mirror;
  final String? mirror_interval;
  final bool? private;
  final bool? pull_requests;
  final bool? releases;
  final String? repo_name;
  final String? repo_owner;
  final String? service;
  final int? uid;
  final bool? wiki;
  const MigrateRepoOptions({
    this.auth_password,
    this.auth_token,
    this.auth_username,
    this.aws_access_key_id,
    this.aws_secret_access_key,
    this.clone_addr,
    this.description,
    this.issues,
    this.labels,
    this.lfs,
    this.lfs_endpoint,
    this.milestones,
    this.mirror,
    this.mirror_interval,
    this.private,
    this.pull_requests,
    this.releases,
    this.repo_name,
    this.repo_owner,
    this.service,
    this.uid,
    this.wiki,
  });
  factory MigrateRepoOptions.fromJson(Map<String, dynamic> json) {
    return MigrateRepoOptions(
      auth_password: json['auth_password'] != null
          ? json['auth_password'] as String
          : null,
      auth_token: json['auth_token'] != null
          ? json['auth_token'] as String
          : null,
      auth_username: json['auth_username'] != null
          ? json['auth_username'] as String
          : null,
      aws_access_key_id: json['aws_access_key_id'] != null
          ? json['aws_access_key_id'] as String
          : null,
      aws_secret_access_key: json['aws_secret_access_key'] != null
          ? json['aws_secret_access_key'] as String
          : null,
      clone_addr: json['clone_addr'] != null
          ? json['clone_addr'] as String
          : null,
      description: json['description'] != null
          ? json['description'] as String
          : null,
      issues: json['issues'] != null ? json['issues'] as bool : null,
      labels: json['labels'] != null ? json['labels'] as bool : null,
      lfs: json['lfs'] != null ? json['lfs'] as bool : null,
      lfs_endpoint: json['lfs_endpoint'] != null
          ? json['lfs_endpoint'] as String
          : null,
      milestones: json['milestones'] != null
          ? json['milestones'] as bool
          : null,
      mirror: json['mirror'] != null ? json['mirror'] as bool : null,
      mirror_interval: json['mirror_interval'] != null
          ? json['mirror_interval'] as String
          : null,
      private: json['private'] != null ? json['private'] as bool : null,
      pull_requests: json['pull_requests'] != null
          ? json['pull_requests'] as bool
          : null,
      releases: json['releases'] != null ? json['releases'] as bool : null,
      repo_name: json['repo_name'] != null ? json['repo_name'] as String : null,
      repo_owner: json['repo_owner'] != null
          ? json['repo_owner'] as String
          : null,
      service: json['service'] != null ? json['service'] as String : null,
      uid: json['uid'] != null ? (json['uid'] as num).toInt() : null,
      wiki: json['wiki'] != null ? json['wiki'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (auth_password != null) map['auth_password'] = auth_password!;
    if (auth_token != null) map['auth_token'] = auth_token!;
    if (auth_username != null) map['auth_username'] = auth_username!;
    if (aws_access_key_id != null)
      map['aws_access_key_id'] = aws_access_key_id!;
    if (aws_secret_access_key != null)
      map['aws_secret_access_key'] = aws_secret_access_key!;
    if (clone_addr != null) map['clone_addr'] = clone_addr!;
    if (description != null) map['description'] = description!;
    if (issues != null) map['issues'] = issues!;
    if (labels != null) map['labels'] = labels!;
    if (lfs != null) map['lfs'] = lfs!;
    if (lfs_endpoint != null) map['lfs_endpoint'] = lfs_endpoint!;
    if (milestones != null) map['milestones'] = milestones!;
    if (mirror != null) map['mirror'] = mirror!;
    if (mirror_interval != null) map['mirror_interval'] = mirror_interval!;
    if (private != null) map['private'] = private!;
    if (pull_requests != null) map['pull_requests'] = pull_requests!;
    if (releases != null) map['releases'] = releases!;
    if (repo_name != null) map['repo_name'] = repo_name!;
    if (repo_owner != null) map['repo_owner'] = repo_owner!;
    if (service != null) map['service'] = service!;
    if (uid != null) map['uid'] = uid!;
    if (wiki != null) map['wiki'] = wiki!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MigrateRepoOptions &&
          auth_password == other.auth_password &&
          auth_token == other.auth_token &&
          auth_username == other.auth_username &&
          aws_access_key_id == other.aws_access_key_id &&
          aws_secret_access_key == other.aws_secret_access_key &&
          clone_addr == other.clone_addr &&
          description == other.description &&
          issues == other.issues &&
          labels == other.labels &&
          lfs == other.lfs &&
          lfs_endpoint == other.lfs_endpoint &&
          milestones == other.milestones &&
          mirror == other.mirror &&
          mirror_interval == other.mirror_interval &&
          private == other.private &&
          pull_requests == other.pull_requests &&
          releases == other.releases &&
          repo_name == other.repo_name &&
          repo_owner == other.repo_owner &&
          service == other.service &&
          uid == other.uid &&
          wiki == other.wiki;
  @override
  int get hashCode => Object.hashAll([
    auth_password,
    auth_token,
    auth_username,
    aws_access_key_id,
    aws_secret_access_key,
    clone_addr,
    description,
    issues,
    labels,
    lfs,
    lfs_endpoint,
    milestones,
    mirror,
    mirror_interval,
    private,
    pull_requests,
    releases,
    repo_name,
    repo_owner,
    service,
    uid,
    wiki,
  ]);
  @override
  String toString() =>
      'MigrateRepoOptions(auth_password: $auth_password, auth_token: $auth_token, auth_username: $auth_username, aws_access_key_id: $aws_access_key_id, aws_secret_access_key: $aws_secret_access_key, clone_addr: $clone_addr, description: $description, issues: $issues, labels: $labels, lfs: $lfs, lfs_endpoint: $lfs_endpoint, milestones: $milestones, mirror: $mirror, mirror_interval: $mirror_interval, private: $private, pull_requests: $pull_requests, releases: $releases, repo_name: $repo_name, repo_owner: $repo_owner, service: $service, uid: $uid, wiki: $wiki)';
}
