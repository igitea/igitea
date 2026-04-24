part of 'generated_models.dart';

/// CreateOrUpdateSecretOption options when creating or updating secret
class CreateOrUpdateSecretOption {
  final String? data;
  final String? description;
  const CreateOrUpdateSecretOption({this.data, this.description});
  factory CreateOrUpdateSecretOption.fromJson(Map<String, dynamic> json) {
    return CreateOrUpdateSecretOption(
      data: json['data'] != null ? json['data'] as String : null,
      description: json['description'] != null
          ? json['description'] as String
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) map['data'] = data!;
    if (description != null) map['description'] = description!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateOrUpdateSecretOption &&
          data == other.data &&
          description == other.description;
  @override
  int get hashCode => Object.hash(data, description);
  @override
  String toString() =>
      'CreateOrUpdateSecretOption(data: $data, description: $description)';
}
