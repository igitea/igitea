part of 'generated_models.dart';

/// AddCollaboratorOption options when adding a user as a collaborator of a repository
class AddCollaboratorOption {
  final String? permission;
  const AddCollaboratorOption({this.permission});
  factory AddCollaboratorOption.fromJson(Map<String, dynamic> json) {
    return AddCollaboratorOption(
      permission: json['permission'] != null
          ? json['permission'] as String
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (permission != null) map['permission'] = permission!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddCollaboratorOption && permission == other.permission;
  @override
  int get hashCode => permission.hashCode;
  @override
  String toString() => 'AddCollaboratorOption(permission: $permission)';
}
