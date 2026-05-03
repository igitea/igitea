part of 'generated_models.dart';

/// RenameOrgOption options when renaming an organization
class RenameOrgOption {
  final String? new_name;
  const RenameOrgOption({
    this.new_name,
  });
  factory RenameOrgOption.fromJson(Map<String, dynamic> json) {
    return RenameOrgOption(
      new_name: json['new_name'] != null ? json['new_name'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (new_name != null) map['new_name'] = new_name!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenameOrgOption &&
          new_name == other.new_name;
  @override
  int get hashCode => new_name.hashCode;
  @override
  String toString() => 'RenameOrgOption(new_name: $new_name)';
}
