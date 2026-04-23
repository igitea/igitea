part of 'generated_models.dart';

/// CreateForkOption options for creating a fork
class CreateForkOption {
  final String? name;
  final String? organization;
  const CreateForkOption({
    this.name,
    this.organization,
  });
  factory CreateForkOption.fromJson(Map<String, dynamic> json) {
    return CreateForkOption(
      name: json['name'] != null ? json['name'] as String : null,
      organization: json['organization'] != null ? json['organization'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name!;
    if (organization != null) map['organization'] = organization!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateForkOption &&
          name == other.name &&
          organization == other.organization;
  @override
  int get hashCode => Object.hash(name, organization);
  @override
  String toString() => 'CreateForkOption(name: $name, organization: $organization)';
}
