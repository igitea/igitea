part of 'generated_models.dart';

/// UpdateBranchProtectionPriories a list to update the branch protection rule priorities
class UpdateBranchProtectionPriories {
  final List<int>? ids;
  const UpdateBranchProtectionPriories({this.ids});
  factory UpdateBranchProtectionPriories.fromJson(Map<String, dynamic> json) {
    return UpdateBranchProtectionPriories(
      ids: json['ids'] != null
          ? (json['ids'] as List<dynamic>)
                .map((e) => (e as num).toInt())
                .toList()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (ids != null) map['ids'] = ids!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateBranchProtectionPriories && ids == other.ids;
  @override
  int get hashCode => ids.hashCode;
  @override
  String toString() => 'UpdateBranchProtectionPriories(ids: $ids)';
}
