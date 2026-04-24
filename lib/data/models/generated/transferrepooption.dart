part of 'generated_models.dart';

/// TransferRepoOption options when transfer a repository's ownership
class TransferRepoOption {
  final String? new_owner;
  final List<int>? team_ids;
  const TransferRepoOption({this.new_owner, this.team_ids});
  factory TransferRepoOption.fromJson(Map<String, dynamic> json) {
    return TransferRepoOption(
      new_owner: json['new_owner'] != null ? json['new_owner'] as String : null,
      team_ids: json['team_ids'] != null
          ? (json['team_ids'] as List<dynamic>)
                .map((e) => (e as num).toInt())
                .toList()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (new_owner != null) map['new_owner'] = new_owner!;
    if (team_ids != null) map['team_ids'] = team_ids!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferRepoOption &&
          new_owner == other.new_owner &&
          team_ids == other.team_ids;
  @override
  int get hashCode => Object.hash(new_owner, team_ids);
  @override
  String toString() =>
      'TransferRepoOption(new_owner: $new_owner, team_ids: $team_ids)';
}
