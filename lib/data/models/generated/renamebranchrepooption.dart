part of 'generated_models.dart';

/// RenameBranchRepoOption options when renaming a branch in a repository
class RenameBranchRepoOption {
  final String? name;
  const RenameBranchRepoOption({this.name});
  factory RenameBranchRepoOption.fromJson(Map<String, dynamic> json) {
    return RenameBranchRepoOption(
      name: json['name'] != null ? json['name'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenameBranchRepoOption && name == other.name;
  @override
  int get hashCode => name.hashCode;
  @override
  String toString() => 'RenameBranchRepoOption(name: $name)';
}
