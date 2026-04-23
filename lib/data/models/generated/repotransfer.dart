part of 'generated_models.dart';

/// RepoTransfer represents a pending repo transfer
class RepoTransfer {
  final User? doer;
  final User? recipient;
  final List<Team>? teams;
  const RepoTransfer({
    this.doer,
    this.recipient,
    this.teams,
  });
  factory RepoTransfer.fromJson(Map<String, dynamic> json) {
    return RepoTransfer(
      doer: json['doer'] != null ? User.fromJson(json['doer'] as Map<String, dynamic>) : null,
      recipient: json['recipient'] != null ? User.fromJson(json['recipient'] as Map<String, dynamic>) : null,
      teams: json['teams'] != null ? (json['teams'] as List<dynamic>).map((e) => Team.fromJson(e as Map<String, dynamic>)).toList() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (doer != null) map['doer'] = doer!.toJson();
    if (recipient != null) map['recipient'] = recipient!.toJson();
    if (teams != null) map['teams'] = teams!.map((e) => e.toJson()).toList();
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepoTransfer &&
          doer == other.doer &&
          recipient == other.recipient &&
          teams == other.teams;
  @override
  int get hashCode => Object.hash(doer, recipient, teams);
  @override
  String toString() => 'RepoTransfer(doer: $doer, recipient: $recipient, teams: $teams)';
}
